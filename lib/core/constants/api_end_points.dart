import 'package:flutter_dotenv/flutter_dotenv.dart';

class EndPoints {
  // static const userProfile = 'user_profile';
  // static const onboardingData = 'onboarding_data';
  // static const fcmToken = 'fcm_token';
  // static const clearFcmToken = 'clear_fcm_token';
  // static const login = 'login';
  // static const signUp = 'sign_up';
  // static const resetPassword = 'reset_password';

  static final masjidLocation = dotenv.env['API_END_POINT']!;
}
