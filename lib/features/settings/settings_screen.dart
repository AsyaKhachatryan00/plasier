import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:plasier/core/config/constants/app_assets.dart';
import 'package:plasier/core/config/theme/app_colors.dart';
import 'package:plasier/core/route/routes.dart';
import 'package:plasier/features/main/controller/main_controller.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late MainController _controller;
  RxBool get _isNotsOn => _controller.isNotsOn;
  RxBool get _isPremium => _controller.isPremium;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<MainController>()) {
      _controller = Get.find<MainController>();
    } else {
      _controller = Get.put(MainController());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        leading: BackButton(color: AppColors.blue),
        title: Text(
          'Einstellungen',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
            fontSize: 17.sp,
            color: AppColors.black,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 16.h),
            Obx(
              () => InkWell(
                onTap: () {
                  if (!_isPremium.value) {
                    Get.toNamed(RouteLink.premium);
                  }
                },
                child: Container(
                  height: 148.h,
                  width: 343.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    color: AppColors.aliceBlue,
                  ),
                  child: _isPremium.value
                      ? Image.asset(
                          AppImages.premiumTrue,
                          width: 238.w,
                          height: 159.h,
                        )
                      : Stack(
                          children: [
                            Positioned(
                              left: 8,
                              top: -7,
                              child: Image.asset(
                                AppImages.premiumBtnText,
                                width: 169.w,
                                height: 168.74313056978397.h,
                              ),
                            ),
                            Positioned(
                              left: 140.w,
                              child: Image.asset(
                                AppImages.image,
                                width: 222.w,
                                height: 148.h,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                color: AppColors.whiteSmoke,
              ),
              child: ListTile(
                title: Text(
                  'Benachrichtigungen',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 17.sp,
                    color: AppColors.black,
                  ),
                ),
                trailing: Obx(
                  () => CupertinoSwitch(
                    value: _isNotsOn.value,
                    onChanged: (value) => _controller.setNots(value),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            ListTile(
              tileColor: AppColors.whiteSmoke,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(16.r),
              ),
              title: Text(
                'Datenschutzrichtlinie',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 17.sp,
                  color: AppColors.black,
                ),
              ),
              trailing: SvgPicture.asset(
                AppSvgs.privacy,
                colorFilter: ColorFilter.mode(
                  AppColors.dogeBlue,
                  BlendMode.srcIn,
                ),
                width: 24.w,
                height: 24.h,
              ),
            ),

            SizedBox(height: 16.h),

            ListTile(
              tileColor: AppColors.whiteSmoke,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(16.r),
              ),
              title: Text(
                'Nutzungsbedingungen',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 17.sp,
                  color: AppColors.black,
                ),
              ),
              trailing: SvgPicture.asset(
                AppSvgs.terms,
                colorFilter: ColorFilter.mode(
                  AppColors.dogeBlue,
                  BlendMode.srcIn,
                ),
                width: 24.w,
                height: 24.h,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
