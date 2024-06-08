import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopping_app/core/common/enums/enums.dart';
import 'package:shopping_app/core/common/widgets/app_button_widget.dart';
import 'package:shopping_app/core/values/color_manager.dart';

class AppSelectButton extends StatelessWidget {
  final void Function()? onTap;
  final String? text;
  final Widget? child;
  final AppButtonSelectStyle buttonSelectStyle;
  final bool selected;
  final bool useLeftPadding;
  const AppSelectButton({
    super.key,
    this.onTap,
    this.text,
    this.buttonSelectStyle = AppButtonSelectStyle.background,
    this.child,
    this.selected = false,
    required this.useLeftPadding,
  }) : assert(child != null || text != null,
            'You must provide a child widget or the text for the button');

  @override
  Widget build(BuildContext context) {
    bool backgroundSelectStyle =
        buttonSelectStyle == AppButtonSelectStyle.background;
    return Padding(
      padding: EdgeInsetsDirectional.only(start: useLeftPadding ? 10.r : 0),
      child: AppButtonWidget(
        text: text,
        onTap: onTap,
        shrinkToFitChildSize: true,
        textFontSize: 16,
        textFontWeight: FontWeight.w600,
        height: 40,
        padding: EdgeInsetsDirectional.symmetric(horizontal: 20.r),
        textColor: selected && backgroundSelectStyle
            ? ColorManager.white
            : ColorManager.primaryDefault500,
        backgroundColor: selected && backgroundSelectStyle
            ? ColorManager.primaryDefault500
            : ColorManager.transparent,
        borderColor: selected && !backgroundSelectStyle
            ? ColorManager.primaryDefault500
            : ColorManager.primaryLight200,
        child: child,
      ),
    );
  }
}
