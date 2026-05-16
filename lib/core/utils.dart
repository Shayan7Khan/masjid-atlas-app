import 'dart:convert';

import 'package:app_links/app_links.dart';
import 'package:flutter_antonx_boilerplate/core/others/logger_customizations/custom_logger.dart';
import 'package:flutter_antonx_boilerplate/core/services/local_storage_service.dart';
import 'package:flutter_antonx_boilerplate/locator.dart';
import 'package:flutter_antonx_boilerplate/ui/screens/home_screens/home_screen.dart';
import 'package:get/route_manager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Utils {
  final _localStorageService = locator<LocalStorageService>();
  final supabase = Supabase.instance.client;
  final CustomLogger log = CustomLogger(className: 'Utils');

  void deepLinks() {
    final appLinks = AppLinks();

    appLinks.uriLinkStream.listen((uri) async {
      log.d("DEEP LINK: $uri");

      if (uri.scheme == 'antonx' && uri.host == 'facebook-login') {
        log.d("MATCHED FACEBOOK LOGIN REDIRECT");
        final session = supabase.auth.currentSession;
        if (session != null) {
          _localStorageService.accessToken = session.accessToken;
          _localStorageService.refreshToken = session.refreshToken;
          _localStorageService.isLoggedIn = true;

          final user = session.user;
          _localStorageService.userData = jsonEncode({
            "id": user.id,
            "email": user.email,
            "name":
                user.userMetadata?["name"] ?? user.userMetadata?["full_name"],
            "avatar":
                user.userMetadata?["picture"] ??
                user.userMetadata?["avatar_url"],
          });
        }
        Get.offAll(() => HomeScreen());
      }
    });
  }
}
