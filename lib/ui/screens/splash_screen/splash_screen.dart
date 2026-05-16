import 'package:flutter/material.dart';
import 'package:flutter_antonx_boilerplate/core/constants/strings.dart';
import 'package:flutter_antonx_boilerplate/core/constants/styles.dart';
import 'package:flutter_antonx_boilerplate/ui/screens/splash_screen/splash_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SplashViewModel(),
      child: Consumer<SplashViewModel>(
        builder: (context, model, child) {
          return Scaffold(
            body: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/splash_background_image.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 0.h,
                  left: 329.w,
                  child: Image.asset('assets/images/background_image_3.png'),
                ),
                Positioned(
                  top: 30.h,
                  left: 69.w,
                  right: 57.w,
                  child: Image.asset('assets/images/background_image_2.png'),
                ),
                Positioned(
                  top: 187.h,
                  left: 0.w,
                  right: 350.w,
                  child: Image.asset('assets/images/background_image_4.png'),
                ),
                Positioned(
                  top: 600.h,
                  left: 329.w,
                  right: 0.w,
                  child: Image.asset('assets/images/background_image_5.png'),
                ),
                Positioned(
                  top: 154.86.h,
                  bottom: 154.86.h,

                  left: 30.w,
                  right: 13,
                  child: Image.asset('assets/images/background_image_6.png'),
                ),
                Positioned(
                  top: 550.h,
                  left: 70.w,
                  child: Text(
                    title,
                    style: titleStyle.copyWith(fontSize: 60.sp),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
