import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopping_app/core/values/color_manager.dart';

class AppButtonWidget extends StatelessWidget {
  final void Function()? onTap;
  final double? width;
  final double? height;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final Color? textColor;
  final double? textFontSize;
  final FontWeight? textFontWeight;
  final String? text;
  final Widget? child;
  final AlignmentGeometry textAlignment;
  final bool shrinkToFitChildSize;
  final EdgeInsetsGeometry? padding;
  const AppButtonWidget({
    super.key,
    this.onTap,
    this.height = 50,
    this.width,
    this.backgroundColor,
    this.borderRadius,
    this.borderColor,
    this.borderWidth,
    this.textColor,
    this.textFontSize,
    this.textFontWeight,
    this.text,
    this.child,
    this.shrinkToFitChildSize = false,
    this.textAlignment = AlignmentDirectional.center,
    this.padding,
  }) : assert(child != null || text != null,
            'You must provide a child widget or the text for the button');

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: shrinkToFitChildSize ? null : width?.r ?? double.infinity,
        padding: padding,
        height: height?.r,
        alignment: textAlignment,
        decoration: BoxDecoration(
          color: backgroundColor ?? ColorManager.primaryDefault500,
          borderRadius: BorderRadius.circular(borderRadius?.r ?? 100.r),
          border: Border.all(
            color: borderColor ?? ColorManager.transparent,
            width: borderWidth?.r ?? 1.r,
          ),
        ),
        child: child ??
            Text(
              text!,
              textAlign: TextAlign.center,
              style: themeData.textTheme.titleMedium!.copyWith(
                color: textColor ?? ColorManager.white,
                fontSize: textFontSize ?? 14,
                fontWeight: textFontWeight ?? FontWeight.bold,
              ),
            ),
      ),
    );
  }
}
