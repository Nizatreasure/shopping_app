import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shopping_app/core/values/asset_manager.dart';
import 'package:shopping_app/core/values/color_manager.dart';

import '../enums/enums.dart';

class ModifyQuantityButton extends StatelessWidget {
  final bool enabled;
  final void Function()? onTap;
  final ModifyQuantityButtonType buttonType;
  final double buttonSize;
  const ModifyQuantityButton({
    super.key,
    required this.buttonType,
    required this.enabled,
    required this.onTap,
    this.buttonSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    Color color =
        enabled ? ColorManager.primaryDefault500 : ColorManager.primaryLight300;
    String asset = buttonType == ModifyQuantityButtonType.add
        ? AppAssetManager.addCircle
        : AppAssetManager.minusCircle;
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        color: ColorManager.transparent,
        width: buttonSize.r,
        height: buttonSize.r,
        child: SvgPicture.asset(
          asset,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        ),
      ),
    );
  }
}
