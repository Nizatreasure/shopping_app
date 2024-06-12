import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shopping_app/core/values/asset_manager.dart';
import 'package:shopping_app/core/values/string_manager.dart';

class AppEmptyDataWidget extends StatelessWidget {
  final String text;
  final bool isReview;
  const AppEmptyDataWidget({
    super.key,
    this.text = StringManager.noProduct,
    this.isReview = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: const Alignment(0, -0.3),
      padding: EdgeInsetsDirectional.symmetric(horizontal: 30.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.only(start: 25.r),
            child: SvgPicture.asset(
              isReview ? AppAssetManager.noReview : AppAssetManager.noProduct,
              height: 100.r,
            ),
          ),
          SizedBox(height: 20.r),
          Text(
            text,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
