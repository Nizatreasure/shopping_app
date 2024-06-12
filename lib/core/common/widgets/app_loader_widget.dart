import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:shopping_app/core/values/asset_manager.dart';
import 'package:shopping_app/core/values/color_manager.dart';
import 'package:shopping_app/core/values/string_manager.dart';
import 'package:shopping_app/main.dart';

class AppLoaderWidget {
  static BuildContext? _context;

  static showLoader({String? message}) async {
    if (_context?.mounted ?? false) {
      dismissLoader();
    }

    showDialog(
      barrierDismissible: false,
      useRootNavigator: true,
      // barrierColor: Theme.of(MyApp.navigatorKey.currentContext!)
      //     .bottomSheetTheme
      //     .modalBarrierColor,
      barrierColor: ColorManager.white.withOpacity(0.5),
      context: MyApp.navigatorKey.currentContext!,
      builder: (pageContext) {
        _context = pageContext;
        return PopScope(
          canPop: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      blendMode: BlendMode.srcIn,
                      child: Container(
                        color: ColorManager.transparent,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      LottieBuilder.asset(
                        AppAssetManager.loadingLottie,
                        fit: BoxFit.cover,
                        width: 80.r,
                      ),
                      SizedBox(height: 20.r),
                      Text(
                        message ??
                            '${StringManager.processing}... ${StringManager.pleaseWait}...',
                        style: Theme.of(MyApp.navigatorKey.currentContext!)
                            .textTheme
                            .headlineMedium!,
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  static dismissLoader() async {
    if (_context != null) {
      _context!.pop();
      _context = null;
    }
  }
}
