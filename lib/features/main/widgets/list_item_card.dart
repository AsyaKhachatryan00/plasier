import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:plasier/core/config/constants/app_assets.dart';
import 'package:plasier/core/config/theme/app_colors.dart';
import 'package:plasier/models/recipe.dart';

class ListItemCard extends StatelessWidget {
  const ListItemCard({required this.recipe, super.key});
  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 80.h,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: AppColors.aliceBlue,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                recipe.createdDate.day.toString(),
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontSize: 20.sp,
                  color: AppColors.blue,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                DateFormat.MMM().format(recipe.createdDate),
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontSize: 13.sp,
                  color: AppColors.black.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 4.w),
        Container(
          height: 80.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: AppColors.lavanderBlush,
          ),

          padding: EdgeInsets.symmetric(horizontal: 16.w),

          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: recipe.status == Status.ready ? 190.w : 140.w,
                child: Text(
                  recipe.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    height: 0.84,
                    letterSpacing: -0.56,
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              if (recipe.status == Status.ready)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(AppSvgs.done),
                    SizedBox(height: 4.w),
                    Text(
                      'Bereit',
                      style: Theme.of(
                        context,
                      ).textTheme.displayMedium?.copyWith(fontSize: 14.sp),
                    ),
                  ],
                ),
            ],
          ),
        ),
        SizedBox(width: 16.w),

        if (recipe.status == Status.dries)
          Column(
            children: [
              Icon(Icons.timer, color: AppColors.blue.withValues(alpha: 0.5)),
              SizedBox(height: 4.w),
              Text(
                'Trocknend',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontSize: 14.sp,
                  color: AppColors.blue,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
