import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shopping_app/core/common/functions/functions.dart';
import 'package:shopping_app/core/values/asset_manager.dart';
import 'package:shopping_app/core/values/color_manager.dart';

class ProductReviewWidget extends StatelessWidget {
  const ProductReviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: 30.r),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40.r,
            width: 40.r,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              color: ColorManager.primaryLight200,
              shape: BoxShape.circle,
            ),
            child: Image.asset(AppAssetManager.preview, fit: BoxFit.cover),
          ),
          SizedBox(width: 15.r),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNameAndReviewDate(themeData),
                SizedBox(height: 5.r),
                _buildReviewRating(themeData),
                SizedBox(height: 10.r),
                Text(
                  'Perfect for keeping your feet dry and warm in damp conditions.',
                  style:
                      themeData.textTheme.bodySmall!.copyWith(height: 22 / 12),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameAndReviewDate(ThemeData themeData) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Nolan Caulder',
            style: themeData.textTheme.titleMedium!.copyWith(
                fontSize: 14, fontWeight: FontWeight.bold, height: 24 / 14),
          ),
        ),
        Text(
          formatDate(DateTime.now()),
          style: themeData.textTheme.bodySmall!.copyWith(letterSpacing: 0.2),
        ),
      ],
    );
  }

  Widget _buildReviewRating(ThemeData themeData) {
    return RatingBar(
      ignoreGestures: true,
      initialRating: 4,
      itemSize: 10.r,
      itemPadding: EdgeInsetsDirectional.only(end: 6.r),
      ratingWidget: RatingWidget(
        full: SvgPicture.asset(AppAssetManager.starFilled),
        half: SvgPicture.asset(AppAssetManager.starEmpty),
        empty: SvgPicture.asset(AppAssetManager.starEmpty),
      ),
      onRatingUpdate: (rating) {},
    );
  }
}
