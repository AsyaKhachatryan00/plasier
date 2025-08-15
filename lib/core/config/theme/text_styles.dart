import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:plasier/core/config/theme/app_colors.dart';

final class AppTextStyle {
  AppTextStyle._();

  static TextStyle displayMedium = TextStyle(
    fontFamily: 'Sf Pro',
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  static TextStyle displaySmall = TextStyle(
    fontFamily: 'Sf Pro',
    fontSize: 10.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.white,
  );

  static TextStyle displayLarge = TextStyle(
    fontFamily: 'Sf Pro',
    fontSize: 28.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );

  static TextStyle titleSmall = TextStyle(
    fontFamily: 'Sf Pro',
    fontSize: 15.sp,
    fontWeight: FontWeight.w400,
  );
}
