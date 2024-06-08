import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopping_app/core/common/widgets/back_button_widget.dart';

PreferredSizeWidget appbarWidget(
  BuildContext context, {
  required String title,
  bool centerTitle = true,
  double toolbarAdditionalHeight = 0,
  bool largeTitle = false,
  List<Widget>? actions,
  bool showBackButton = true,
  void Function()? onTapBackButton,
  double? titleSpacing,
  PreferredSizeWidget? bottom,
}) {
  ThemeData themeData = Theme.of(context);
  return AppBar(
    leadingWidth: 70.r,
    titleSpacing: titleSpacing,
    leading: showBackButton
        ? BackButtonWidget(
            onTap: onTapBackButton,
            padding: EdgeInsetsDirectional.only(start: 28.r),
          )
        : null,
    title: Text(
      title,
      style: largeTitle
          ? themeData.textTheme.headlineLarge!
              .copyWith(height: 45 / 30, fontSize: 30)
          : themeData.textTheme.titleLarge!.copyWith(
              height: 20 / 16,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2),
    ),
    centerTitle: centerTitle,
    actions: actions != null ? [...actions, SizedBox(width: 30.r)] : null,
    toolbarHeight: kToolbarHeight + toolbarAdditionalHeight,
    bottom: bottom,
  );
}
