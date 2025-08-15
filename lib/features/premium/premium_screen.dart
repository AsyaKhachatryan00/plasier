import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:plasier/core/config/constants/app_assets.dart';
import 'package:plasier/core/config/theme/app_colors.dart';
import 'package:plasier/features/main/controller/main_controller.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MainController controller = Get.isRegistered<MainController>()
        ? Get.find<MainController>()
        : Get.put(MainController());

    return Scaffold(
      backgroundColor: AppColors.blue,
      appBar: AppBar(
        backgroundColor: AppColors.blue,
        leading: BackButton(color: AppColors.white),
      ),
      body: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          Positioned(
            top: 0,
            child: Image.asset(AppImages.premium, width: 295.w, height: 230.h),
          ),

          Positioned(
            bottom: 0,
            left: 28.w,
            child: Container(
              width: 160.w,
              height: 418.h,
              padding: EdgeInsets.only(top: 80.h, left: 15.w),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(240.r),
                ),
              ),
              child: Text(
                'Wiederherstellen',
                style: Theme.of(
                  context,
                ).textTheme.displaySmall?.copyWith(fontSize: 16.sp),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 188.w,
            child: InkWell(
              onTap: () => controller.setPremium(),
              child: Container(
                width: 160.w,
                height: 463.h,
                padding: EdgeInsets.only(top: 80.h, left: 7, right: 7.w),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(240.r),
                  ),
                ),
                child: Text(
                  'Unterstützung für \n 0,49 \$',
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.displayMedium?.copyWith(fontSize: 16.sp),
                ),
              ),
            ),
          ),

          Positioned(
            top: 330.h,
            width: 669.w,
            height: 463.h,
            child: IgnorePointer(
              child: Image.asset(AppImages.splash, width: 669.w, height: 463.h),
            ),
          ),
        ],
      ),
    );
  }
}
