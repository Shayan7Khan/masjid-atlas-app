import 'package:flutter/material.dart';
import 'package:flutter_antonx_boilerplate/core/constants/styles.dart';
import 'package:flutter_antonx_boilerplate/ui/screens/auth_screen/auth_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthScreenViewModel(),
      child: Consumer<AuthScreenViewModel>(
        builder: (context, vm, child) {
          return Scaffold(
            backgroundColor: Color(0xFF202020),
            body: SafeArea(
              child: Padding(
                padding: EdgeInsetsGeometry.symmetric(vertical: 30.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Masjid Atlas',
                      style: titleStyle.copyWith(fontSize: 60.sp),
                    ),
                    50.verticalSpace,
                    Opacity(
                      opacity: 0.6,
                      child: Image.asset(
                        'assets/images/auth_image.png',
                        fit: BoxFit.contain,
                        height: 450.h,
                        width: 420.w,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 20.h,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildGoogleButton(vm),
                          20.verticalSpace,
                          _buildFaceBookButton(vm),
                          20.verticalSpace,
                          // _buildAppleButton(vm),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGoogleButton(AuthScreenViewModel vm) {
    return _socialButton(
      imagePath: 'assets/images/google.png',
      text: 'Continue with Google',
      onTap: vm.signInWithGoogle,
    );
  }

  Widget _buildFaceBookButton(AuthScreenViewModel vm) {
    return _socialButton(
      imagePath: 'assets/images/facebook.png',
      text: 'Continue with Facebook',
      onTap: vm.signInWithFaceBook,
    );
  }

  // Widget _buildAppleButton(AuthScreenViewModel vm) {
  //   return _socialButton(
  //     imagePath: 'assets/images/apple-logo.png',
  //     text: 'Continue with Apple',

  //     onTap: () {},
  //   );
  // }

  Widget _socialButton({
    required String imagePath,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: Colors.white24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, height: 22.h),
            12.horizontalSpace,
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
