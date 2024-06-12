import 'package:flutter/material.dart';
import 'package:shopping_app/core/values/color_manager.dart';

import '../enums/enums.dart';

void showAppMaterialBanner(
  BuildContext context, {
  required String text,
  AppSnackbarType type = AppSnackbarType.error,
}) {
  ThemeData themeData = Theme.of(context);

  //close the current banner if any is open before opening another
  ScaffoldMessenger.of(context)
    ..hideCurrentMaterialBanner()
    ..showMaterialBanner(
      MaterialBanner(
        actions: const [SizedBox.shrink()],
        backgroundColor: type == AppSnackbarType.error
            ? ColorManager.errorPrimary700
            : ColorManager.successPrimary700,
        content: Text(
          text,
          style: themeData.textTheme.headlineMedium!
              .copyWith(fontWeight: FontWeight.w500, color: ColorManager.white),
        ),
      ),
    );
  //close the banner after 4 seconds
  Future.delayed(const Duration(seconds: 4)).then((val) {
    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
  });
}
