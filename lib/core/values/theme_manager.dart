import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/constants.dart';
import 'color_manager.dart';

class ThemeManager {
  static ThemeData getLightTheme() {
    return ThemeData.light().copyWith(
      scaffoldBackgroundColor: ColorManager.white,
      primaryColor: ColorManager.primaryDefault500,
      primaryColorDark: ColorManager.primaryBlack900,
      primaryColorLight: ColorManager.primaryLight100,
      textTheme: TextTheme(
        bodySmall: _bodyText(fontSize: 12),
        bodyMedium: _bodyText(fontSize: 14),
        bodyLarge: _bodyText(fontSize: 16),
        headlineLarge: _headlineText(fontSize: 24),
        headlineMedium: _headlineText(fontSize: 20),
        headlineSmall: _headlineText(fontSize: 16),
        titleLarge: _headlineText(fontSize: 14, fontWeight: FontWeight.w500),
        titleMedium: _headlineText(fontSize: 12, fontWeight: FontWeight.w500),
        titleSmall: _headlineText(fontSize: 10, fontWeight: FontWeight.w500),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: ColorManager.white,
        elevation: 0,
        surfaceTintColor: ColorManager.transparent,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: ColorManager.white,
        modalBackgroundColor: ColorManager.white,
        modalBarrierColor: ColorManager.primaryDefault500.withOpacity(0.3),
        clipBehavior: Clip.antiAlias,
        surfaceTintColor: ColorManager.transparent,
        dragHandleSize: Size(44.r, 4.r),
        dragHandleColor: ColorManager.primaryLight200,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
      ),
    );
  }

  static TextStyle _bodyText({required double fontSize}) {
    return TextStyle(
      color: ColorManager.primaryDefault500,
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
      fontFamily: AppConstants.fontFamily,
    );
  }

  static TextStyle _headlineText({
    required double fontSize,
    FontWeight? fontWeight,
  }) {
    return TextStyle(
      color: ColorManager.primaryDefault500,
      fontSize: fontSize,
      fontWeight: fontWeight ?? FontWeight.w700,
      fontFamily: AppConstants.fontFamily,
    );
  }
}
