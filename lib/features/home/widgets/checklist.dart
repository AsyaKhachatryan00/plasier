import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:plasier/core/config/theme/app_colors.dart';

class ChecklistCard extends StatelessWidget {
  final ChecklistItem item;
  final VoidCallback onTap;

  const ChecklistCard({required this.item, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xff545456).withValues(alpha: 0.34),
            width: 0.33,
          ),
        ),
      ),
      child: SizedBox(
        width: 343.w,

        child: ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            item.text,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontSize: 17.sp,
              color: AppColors.black,
            ),
          ),
          trailing: item.checked
              ? Icon(CupertinoIcons.checkmark_alt, color: Color(0xff007AFF))
              : null,
          onTap: onTap,
        ),
      ),
    );
  }
}

class ChecklistItem {
  String text;
  bool checked;
  ChecklistItem(this.text, {this.checked = false});
}
