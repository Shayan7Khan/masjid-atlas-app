import 'package:flutter_antonx_boilerplate/core/enums/view_state.dart';
import 'package:flutter_antonx_boilerplate/core/others/logger_customizations/custom_logger.dart';
import 'package:flutter_antonx_boilerplate/locator.dart';
import 'package:flutter_antonx_boilerplate/ui/screens/home_screens/home_screen.dart';
import 'package:get/get.dart';
import 'package:flutter_antonx_boilerplate/core/others/base_view_model.dart';
import 'package:flutter_antonx_boilerplate/core/services/auth_service.dart';

class AuthScreenViewModel extends BaseViewModel {
  final AuthService _authService = locator<AuthService>();
  final CustomLogger log = CustomLogger(className: 'LoginViewModel');
  //google
  Future<void> signInWithGoogle() async {
    setState(ViewState.busy);
    final success = await _authService.signupWithGmail();
    setState(ViewState.idle);
    if (success) {
      log.d("Google Sign In successful");
      Get.offAll(HomeScreen());
    } else {
      log.e("Google Sign-In failed");
    }
  }

  //facebook
  Future<void> signInWithFaceBook() async {
    setState(ViewState.busy);
    await _authService.signupWithFacebook();
    setState(ViewState.idle);
  }

  void signInWithApple() {}
}
