import 'dart:convert';
import 'dart:io';

import 'package:flutter_antonx_boilerplate/core/models/body/login_body.dart';
import 'package:flutter_antonx_boilerplate/core/models/body/reset_password_body.dart';
import 'package:flutter_antonx_boilerplate/core/models/body/signup_body.dart';
import 'package:flutter_antonx_boilerplate/core/models/other_models/user_profile.dart';
import 'package:flutter_antonx_boilerplate/core/models/responses/auth_response.dart';
import 'package:flutter_antonx_boilerplate/core/models/user.dart';
import 'package:flutter_antonx_boilerplate/core/others/logger_customizations/custom_logger.dart';
import 'package:flutter_antonx_boilerplate/core/services/device_info_service.dart';
import 'package:flutter_antonx_boilerplate/core/services/local_storage_service.dart';
import 'package:flutter_antonx_boilerplate/core/services/mock_database_service.dart';
import 'package:flutter_antonx_boilerplate/core/services/notifications_service.dart';
import 'package:flutter_antonx_boilerplate/locator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User, AuthResponse;

///
/// [AuthService] class contains all authentication related logic with following
/// methods:
///
/// [doSetup]: This method contains all the initial authentication like checking
/// login status, onboarding status and other related initial app flow setup.
///
/// [signupWithEmailAndPassword]: This method is used for signup with email and password.
///
/// [signupWithApple]:
///
/// [signupWithGmail]:
///
/// [signupWithFacebook]:
///
/// [logout]:
///

class AuthService {
  late bool isLogin;
  final _localStorageService = locator<LocalStorageService>();
  final _mockDbService = locator<MockDatabaseService>();
  UserProfile? userProfile;
  User? currentUser;
  String? fcmToken;
  final supabase = Supabase.instance.client;
  static final Logger log = CustomLogger(className: 'AuthService');

  ///
  /// [doSetup] Function does the following things:
  ///   1) Checks if the user is logged then:
  ///       a) Get the user profile data
  ///       b) Updates the user FCM Token
  ///
  Future<void> doSetup() async {
    isLogin =
        _localStorageService.isLoggedIn &&
        _localStorageService.accessToken != null;
    if (isLogin) {
      log.d('User is already logged-in');
      await _loadUserFromStorage();
      await _updateFcmToken();
    } else {
      log.d('@doSetup: User is not logged-in');
    }
  }

  Future<void> _loadUserFromStorage() async {
    final userDataString = _localStorageService.userData;
    if (userDataString != null) {
      try {
        final userData = jsonDecode(userDataString);
        currentUser = User.fromJson(userData);
        log.d('Loaded user from storage: ${currentUser?.email}');
      } catch (e) {
        log.e('Error loading user from storage: $e');
      }
    }
  }

  ///
  /// Updating FCM Token here...
  ///
  Future<void> _updateFcmToken() async {
    try {
      final fcmToken = await locator<NotificationsService>().getFcmToken();
      final deviceId = await DeviceInfoService().getDeviceId();
      final response = await _mockDbService.updateFcmToken(deviceId, fcmToken!);
      if (response) {
        userProfile?.fcmToken = fcmToken;
      }
    } catch (e) {
      log.e('Error updating FCM token: $e');
    }
  }

  Future<AuthResponse> signupWithEmailAndPassword(SignUpBody body) async {
    late AuthResponse response;
    // Use mock service for demo
    response = await _mockDbService.createAccount(body);
    if (response.success) {
      // Create user object from signup data
      currentUser = User(
        email: body.email,
        name: body.name,
        phone: body.phone,
        createdAt: DateTime.now(),
      );

      // Save user data to local storage
      _localStorageService.userData = jsonEncode(currentUser!.toJson());
      _localStorageService.accessToken = response.accessToken;
      _localStorageService.isLoggedIn = true;
      isLogin = true;

      userProfile = UserProfile.fromJson(body.toJson());
      await _updateFcmToken();

      log.d('User signed up successfully: ${currentUser?.email}');
    }
    return response;
  }

  Future<AuthResponse> loginWithEmailAndPassword(LoginBody body) async {
    late AuthResponse response;
    // Use mock service for demo
    response = await _mockDbService.loginWithEmailAndPassword(body);
    if (response.success) {
      // Load user data from mock service
      final userData = await _mockDbService.getUserProfile();
      currentUser = User.fromJson(userData);

      _localStorageService.userData = jsonEncode(currentUser!.toJson());
      _localStorageService.accessToken = response.accessToken;
      _localStorageService.isLoggedIn = true;
      isLogin = true;

      await _updateFcmToken();

      log.d('User logged in successfully: ${body.email}');
    }
    return response;
  }

  Future<AuthResponse> resetPassword(ResetPasswordBody body) async {
    final AuthResponse response = await _mockDbService.resetPassword(body);
    if (response.success) {
      _localStorageService.accessToken = response.accessToken;
    }
    return response;
  }

  Future<bool> signupWithGmail() async {
    try {
      GoogleSignIn signIn = GoogleSignIn.instance;
      await signIn.initialize(
        serverClientId: dotenv.env['WEB_CLIENT'],
        clientId: Platform.isAndroid
            ? dotenv.env['ANDROID_CLIENT']
            : dotenv.env['IOS_CLIENT'],
      );
      GoogleSignInAccount account = await signIn.authenticate();
      String idToken = account.authentication.idToken ?? '';
      log.d('Got the idToken: $idToken');
      final authorization =
          await account.authorizationClient.authorizationForScopes([
            'email',
            'profile',
          ]) ??
          await account.authorizationClient.authorizeScopes([
            'email',
            'profile',
          ]);
      log.d('Got the accesstoken: $authorization');

      final response = await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: authorization.accessToken,
      );
      log.d('got the response from supabase. response: $response');
      final session = response.session;
      if (session != null) {
        _localStorageService.accessToken = session.accessToken;
        _localStorageService.refreshToken = session.refreshToken;
        _localStorageService.isLoggedIn = true;
        final user = session.user;
        _localStorageService.userData = jsonEncode({
          "id": user.id,
          "email": user.email,
          "name": user.userMetadata?["name"],
          "avatar": user.userMetadata?["picture"],
        });
        log.d('user data stored in local storage');
      }
      return true;
    } catch (e) {
      log.e('Error signing in with google: $e');
      return false;
    }
  }

  Future<void> signupWithFacebook() async {
    try {
      await supabase.auth.signInWithOAuth(
        OAuthProvider.facebook,
        redirectTo: "antonx://facebook-login",
        authScreenLaunchMode: LaunchMode.externalApplication,
      );
      log.d('FaceBook OAtuth completed');
    } catch (e) {
      log.e("Facebook OAuth error: $e");
    }
  }

  Future<void> logout() async {
    isLogin = false;
    userProfile = null;
    currentUser = null;

    try {
      // Clear FCM token from server
      final deviceId = await DeviceInfoService().getDeviceId();
      await _mockDbService.clearFcmToken(deviceId);
    } catch (e) {
      log.e('Error clearing FCM token: $e');
    }

    // Clear all local storage
    _localStorageService.clearUserData();

    log.d('User logged out successfully');
  }
}
