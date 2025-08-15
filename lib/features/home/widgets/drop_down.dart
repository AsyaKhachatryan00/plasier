import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:plasier/core/config/theme/app_colors.dart';

class DropDown extends StatelessWidget {
  const DropDown({required this.onTap, super.key});
  final Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    final List<String> options = ['Bearbeiten', 'Löschen'];

    return Padding(
      padding: EdgeInsets.only(right: 16.w),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          customButton: Icon(Icons.more_horiz, color: AppColors.primary),
          items: options
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: Container(
                    padding: EdgeInsets.only(right: 16.w, top: 9.h),
                    decoration: BoxDecoration(
                      border: item == 'Löschen'
                          ? null
                          : Border(
                              bottom: BorderSide(
                                width: 8,
                                color: AppColors.black.withValues(alpha: 0.08),
                              ),
                            ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 9.h),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 16.w),
                            child: Text(
                              item,
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    fontSize: 17.sp,
                                    color: item == 'Löschen'
                                        ? AppColors.red
                                        : AppColors.black,
                                  ),
                            ),
                          ),
                          Icon(
                            item == 'Löschen'
                                ? CupertinoIcons.delete
                                : CupertinoIcons.pencil,

                            color: item == 'Löschen'
                                ? AppColors.red
                                : AppColors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) onTap(value);
          },
          dropdownStyleData: DropdownStyleData(
            width: 164.w,
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: Colors.white,
            ),
            offset: Offset(-20.w, -16.h),
          ),
          menuItemStyleData: MenuItemStyleData(padding: EdgeInsets.zero),
        ),
      ),
    );
  }
}
