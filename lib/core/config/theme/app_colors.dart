import 'package:flutter/material.dart';

final class AppColors {
  AppColors._();

  static const Color primary = Color(0xffFF26D5);

  static const Color white = Color(0xffFFFFFF);
  static const Color black = Color(0xFF171717);

  static const Color blue = Color(0xFF24A4FF);
  static const Color dogeBlue = Color(0xff167BFF);
  static const Color aliceBlue = Color(0xFfE0F2FF);
  static const Color lavanderBlush = Color(0xffFFE0F9);

  static const Color whiteSmoke = Color(0xffF7F7F7);

  static const Color heliotrope = Color(0xFFB389FF);
  static const Color blueHaze = Color(0xffC5B7CF);
  static const Color darkgray = Color(0xffB3B3B3);
  static const Color payneGrey = Color(0xff3C3C43);
  static const Color red = Color(0xffFF3B30);
}

final class Appgradient {
  Appgradient._();

  static const Gradient gradient = LinearGradient(
    colors: [AppColors.heliotrope, AppColors.blueHaze],

    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}


/* 
  if (form.control('title').touched)
                        IconButton(
                          onPressed: () => form.control('title').reset(),
                          icon: Icon(
                            Icons.cancel,
                            color: AppColors.payneGrey.withValues(alpha: 0.6),
                          ),
                        ),
 */