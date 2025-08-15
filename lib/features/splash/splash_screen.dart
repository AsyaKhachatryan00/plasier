import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:plasier/core/config/constants/app_assets.dart';
import 'package:plasier/core/config/constants/storage_keys.dart';
import 'package:plasier/core/config/theme/app_colors.dart';
import 'package:plasier/core/route/routes.dart';
import 'package:plasier/core/widgets/custom_button.dart';
import 'package:plasier/core/widgets/dialog_screen.dart';
import 'package:plasier/core/widgets/utils/shared_prefs.dart';
import 'package:plasier/service_locator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  RxBool startAnimations = false.obs;
  late AnimationController _opacityController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _opacityController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _opacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_opacityController)..addListener(updateUi);

    Future.delayed(const Duration(milliseconds: 500), () {
      startAnimations.value = true;
      _opacityController.forward();
    });

    _opacityController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(Duration(microseconds: 3000), () async {
          final isNotificationsOn = locator<SharedPrefs>().getBool(
            StorageKeys.isNotificationsOn,
          );
          if (!isNotificationsOn) {
            openNotDialog();
          }
        });
      }
    });
  }

  void updateUi() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _opacityAnimation.removeListener(updateUi);
    _opacityController.dispose();
  }

  void openNotDialog() {
    showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) => DialogScreen(
        onTap: (value) => locator<SharedPrefs>().setBool(
          StorageKeys.isNotificationsOn,
          value,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue,
      body: Stack(
        children: [
          AnimatedOpacity(
            opacity: 1 - _opacityAnimation.value,
            duration: Duration(milliseconds: 500),
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Positioned(
                  top: 70.h,
                  width: 402.w,
                  height: 402.h,
                  child: Image.asset(AppImages.splashText, fit: BoxFit.cover),
                ),
                Positioned(
                  bottom: -65.h,
                  child: Image.asset(
                    AppImages.splash,
                    height: 463.h,
                    width: 669.w,
                  ),
                ),
              ],
            ),
          ),
          AnimatedOpacity(
            opacity: _opacityController.value,
            duration: Duration(milliseconds: 1000),
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Positioned(
                  top: 70.h,
                  child: Image.asset(
                    AppImages.splashText,
                    width: 243.w,
                    height: 243.h,
                    fit: BoxFit.cover,
                  ),
                ),

                Positioned(
                  top: 313.h,
                  height: 56.h,
                  child: CustomButton(
                    data: 'Continue',
                    onTap: () => Get.offAllNamed(RouteLink.main),
                  ),
                ),

                Positioned(
                  top: 377.h,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.h),
                    child: Row(
                      children: [
                        Container(
                          width: 159.5.w,
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18.r),
                            color: AppColors.white.withValues(alpha: 0.2),
                          ),
                          child: Column(
                            children: [
                              SvgPicture.asset(AppSvgs.privacy),
                              Text(
                                'Datenschutzrichtlinie',
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8.w),

                        Container(
                          width: 159.5.w,
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18.r),
                            color: AppColors.white.withValues(alpha: 0.2),
                          ),
                          child: Column(
                            children: [
                              SvgPicture.asset(AppSvgs.terms),
                              Text(
                                'Nutzungsbedingungen',
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Positioned(
                  bottom: -66.h,
                  height: 463.h,
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset(
                    AppImages.splash,
                    height: 463.h,
                    width: 669.w,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
