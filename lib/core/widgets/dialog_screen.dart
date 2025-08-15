import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plasier/core/config/theme/app_colors.dart';

class DialogScreen extends StatelessWidget {
  const DialogScreen({required this.onTap, super.key});
  final Function(bool)? onTap;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: CupertinoAlertDialog(
        title: Text(
          '"Pläsier – Seifen-Notizen" Would Like to Send You Push Notifications',
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.displayMedium?.copyWith(color: AppColors.black),
        ),

        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: false,
            onPressed: () {
              onTap?.call(false);
              Get.back();
            },
            child: Text(
              "Don't allow",
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: AppColors.blue,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              onTap?.call(true);

              Get.back();
            },
            child: Text(
              "OK",
              style: Theme.of(
                context,
              ).textTheme.displayMedium?.copyWith(color: AppColors.blue),
            ),
          ),
        ],
      ),
    );
  }
}
