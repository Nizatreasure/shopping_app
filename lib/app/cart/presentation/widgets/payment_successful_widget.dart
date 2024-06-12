import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:shopping_app/core/common/widgets/app_button_widget.dart';
import 'package:shopping_app/core/values/asset_manager.dart';
import 'package:shopping_app/core/values/color_manager.dart';
import 'package:shopping_app/core/values/string_manager.dart';

Future<void> showPaymentSuccessModal(BuildContext context) async {
  await showModalBottomSheet(
      context: context,
      builder: (context) {
        return const PaymentSuccessfulWidget();
      });
}

class PaymentSuccessfulWidget extends StatelessWidget {
  const PaymentSuccessfulWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    double viewPadding = MediaQuery.of(context).viewPadding.bottom;
    return AnimatedContainer(
      width: double.infinity,
      duration: const Duration(milliseconds: 100),
      padding: EdgeInsetsDirectional.only(
        start: 30.r,
        end: 20.r,
        bottom: viewPadding + 20.r,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDragHandler(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10.r),
              _buildLottieAnimation(),
              SizedBox(height: 20.r),
              Align(
                alignment: Alignment.center,
                child: Text(
                  StringManager.paymentSuccessful,
                  style: themeData.textTheme.headlineLarge!.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      height: 34 / 24),
                ),
              ),
              SizedBox(height: 30.r),
              Text(
                StringManager.paymentSuccessfulMessage,
                style: themeData.textTheme.headlineMedium!.copyWith(
                  fontWeight: FontWeight.normal,
                  height: 25 / 18,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 40.r),
              AppButtonWidget(
                text: StringManager.done.toUpperCase(),
                shrinkToFitChildSize: true,
                padding: EdgeInsetsDirectional.symmetric(horizontal: 31.5.r),
                onTap: () {
                  context.pop();
                },
              )
            ],
          ),
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

  Widget _buildDragHandler() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsetsDirectional.only(top: 10.r, bottom: 26.r),
        height: 4.r,
        width: 44.r,
        decoration: BoxDecoration(
          color: ColorManager.primaryLight200,
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }
}
