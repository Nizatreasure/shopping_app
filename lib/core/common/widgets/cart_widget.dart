import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shopping_app/core/values/asset_manager.dart';
import 'package:shopping_app/core/values/color_manager.dart';

class CartWidget extends StatelessWidget {
  const CartWidget({super.key});
  final bool hasNotification = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SvgPicture.asset(
          AppAssetManager.cart,
          width: 24.r,
          height: 24.r,
        ),
        if (hasNotification)
          PositionedDirectional(
            top: 4,
            end: 1,
            child: CircleAvatar(
              radius: 4.r,
              backgroundColor: ColorManager.errorDefault500,
            ),
          ),
      ],
    );
  }
}
