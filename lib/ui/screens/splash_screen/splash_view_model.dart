import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_antonx_boilerplate/core/enums/view_state.dart';
import 'package:flutter_antonx_boilerplate/core/others/base_view_model.dart';
import 'package:flutter_antonx_boilerplate/core/others/logger_customizations/custom_logger.dart';
import 'package:flutter_antonx_boilerplate/core/services/auth_service.dart';
import 'package:flutter_antonx_boilerplate/core/services/local_storage_service.dart';
import 'package:flutter_antonx_boilerplate/locator.dart';
import 'package:flutter_antonx_boilerplate/ui/custom_widgets/dialogs/network_error_dialog.dart';
import 'package:flutter_antonx_boilerplate/ui/screens/auth_screen/auth_screen.dart';
import 'package:flutter_antonx_boilerplate/ui/screens/home_screens/home_screen.dart';
import 'package:get/get.dart';

class SplashViewModel extends BaseViewModel {
  final CustomLogger log = CustomLogger(className: 'SplashViewModel');
  final LocalStorageService _localStorageService =
      locator<LocalStorageService>();
  final AuthService _authService = locator<AuthService>();

  SplashViewModel() {
    _initialSetup();
  }

  Future<void> _initialSetup() async {
    setState(ViewState.busy);
    try {
      await _localStorageService.init();
      // Check connectivity
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        Get.dialog(const NetworkErrorDialog());
        return;
      }
      await _authService.doSetup();
      await Future.delayed(Duration(seconds: 3));

      ///
      ///checking if the user is login or not
      ///
      log.d('@_initialSetup. Login State: ${_authService.isLogin}');
      if (_authService.isLogin) {
        Get.off(() => const HomeScreen());
      } else {
        Get.off(() => AuthScreen());
      }
    } catch (e) {
      log.e('Error during initial setup: $e');
    }
  }
}
