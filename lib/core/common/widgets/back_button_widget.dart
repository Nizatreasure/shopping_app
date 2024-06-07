import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shopping_app/core/values/asset_manager.dart';
import 'package:shopping_app/core/values/color_manager.dart';

class BackButtonWidget extends StatelessWidget {
  final void Function()? onTap;
  final String? asset;
  final EdgeInsetsGeometry? padding;
  const BackButtonWidget({
    super.key,
    this.onTap,
    this.asset,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ??
          () {
            context.pop();
          },
      child: Container(
        padding: padding,
        color: ColorManager.transparent,
        alignment: Alignment.centerLeft,
        child: SvgPicture.asset(
          AppAssetManager.arrowLeft,
          width: 24.r,
          height: 24.r,
        ),
      ),
    );
  }
}
