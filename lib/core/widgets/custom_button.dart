import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:plasier/core/config/theme/app_colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.data,
    this.onTap,
    this.height,
    this.textColor,
    this.width,
    this.color,
    this.child,
    this.fontWeight,
    this.size,
  });

  final String? data;
  final void Function()? onTap;
  final double? height;
  final double? width;
  final Color? textColor;
  final Color? color;
  final Widget? child;
  final FontWeight? fontWeight;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? 327.w,
        alignment: Alignment.center,
        height: height ?? 56.h,
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
        decoration: BoxDecoration(
          color: color ?? AppColors.white,
          borderRadius: BorderRadius.circular(18.r),
        ),

        child: data != null
            ? Text(
                data!,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: textColor ?? AppColors.primary,
                  fontWeight: fontWeight,
                  fontSize: size,
                ),
              )
            : child,
      ),
    );
  }
}
