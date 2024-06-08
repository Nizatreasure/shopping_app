import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:shopping_app/core/common/widgets/app_button_widget.dart';
import 'package:shopping_app/core/routes/router.dart';
import 'package:shopping_app/core/values/asset_manager.dart';
import 'package:shopping_app/core/values/color_manager.dart';
import 'package:shopping_app/core/values/string_manager.dart';

class AddedToCartModal extends StatelessWidget {
  const AddedToCartModal({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Container(
      padding: EdgeInsetsDirectional.only(
        bottom: MediaQuery.of(context).viewPadding.bottom + 30.r,
        start: 30.r,
        end: 30.r,
      ),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 30.r),
          _buildLottieAnimation(),
          SizedBox(height: 20.r),
          Text(
            StringManager.addedToCart,
            style: themeData.textTheme.headlineLarge!.copyWith(
                fontSize: 24, fontWeight: FontWeight.w600, height: 34 / 24),
          ),
          SizedBox(height: 5.r),
          Text(
            '1 ${StringManager.itemTotal}',
            style: themeData.textTheme.bodyMedium!.copyWith(
              fontSize: 14,
              color: ColorManager.primaryLight400,
              height: 24 / 14,
            ),
          ),
          SizedBox(height: 20.r),
          _buildButtons(context, themeData),
        ],
      ),
    );
  }

  Widget _buildLottieAnimation() {
    return Container(
      height: 100.r,
      padding: EdgeInsetsDirectional.only(end: 20.r),
      child: OverflowBox(
        maxHeight: 150.r,
        alignment: const AlignmentDirectional(0, -0.35),
        child: LottieBuilder.asset(
          AppAssetManager.successLottie,
          repeat: false,
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context, ThemeData themeData) {
    return Row(
      children: [
        Expanded(
          child: AppButtonWidget(
            text: StringManager.backExplore.toUpperCase(),
            borderColor: ColorManager.primaryLight200,
            backgroundColor: ColorManager.transparent,
            textColor: ColorManager.primaryDefault500,
            onTap: () {
              context
                ..pop()
                ..pop();
            },
          ),
        ),
        SizedBox(width: 15.r),
        Expanded(
          child: AppButtonWidget(
            text: StringManager.toCart.toUpperCase(),
            onTap: () {
              context
                ..pop()
                ..pushNamed(RouteNames.cart);
            },
          ),
        ),
      ],
    );
  }
}
