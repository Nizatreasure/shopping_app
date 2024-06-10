import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shopping_app/core/common/widgets/app_button_widget.dart';
import 'package:shopping_app/core/values/asset_manager.dart';
import 'package:shopping_app/core/values/string_manager.dart';

class AppErrorWidget extends StatelessWidget {
  final String errorMessage;
  final void Function() onTap;
  const AppErrorWidget(
      {super.key, required this.errorMessage, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 30.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.only(start: 25.r),
            child: SvgPicture.asset(
              AppAssetManager.error,
              height: 100.r,
            ),
          ),
          SizedBox(height: 20.r),
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 50.r),
          AppButtonWidget(
            text: StringManager.retry,
            onTap: onTap,
            height: 40,
            width: 150.r,
          ),
          SizedBox(height: 150.r)
        ],
      ),
    );
  }
}
