import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shopping_app/app/discover/data/models/product_review_model.dart';
import 'package:shopping_app/app/discover/presentation/widgets/shimmer_widget.dart';
import 'package:shopping_app/core/common/functions/functions.dart';
import 'package:shopping_app/core/common/widgets/custom_network_image.dart';
import 'package:shopping_app/core/values/asset_manager.dart';
import 'package:shopping_app/core/values/color_manager.dart';

class ProductReviewWidget extends StatefulWidget {
  final ProductReviewModel? review;
  final bool loading;
  const ProductReviewWidget(
      {super.key, required this.review, required this.loading});

  @override
  State<ProductReviewWidget> createState() => _ProductReviewWidgetState();
}

class _ProductReviewWidgetState extends State<ProductReviewWidget> {
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: 30.r),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerWidget(
            loading: widget.loading,
            height: 40,
            width: 40,
            borderRadius: 100,
            child: widget.review == null
                ? const SizedBox()
                : Container(
                    height: 40.r,
                    width: 40.r,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      color: ColorManager.primaryLight200,
                      shape: BoxShape.circle,
                    ),
                    child: CustomNetworkImage(
                      imageUrl: widget.review!.image,
                      key: widget.review!.imageKey,
                      indicatorSize: 15,
                      fit: BoxFit.cover,
                      onRetry: () {
                        setState(() {
                          widget.review!.copyWith(imageKey: UniqueKey());
                        });
                      },
                    ),
                  ),
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
                ShimmerWidget(
                  loading: widget.loading,
                  borderRadius: 6,
                  height: 60,
                  child: widget.review == null
                      ? const SizedBox()
                      : Text(
                          widget.review!.review,
                          style: themeData.textTheme.bodySmall!
                              .copyWith(height: 22 / 12),
                        ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameAndReviewDate(ThemeData themeData) {
    return ShimmerWidget(
      loading: widget.loading,
      borderRadius: 3.r,
      height: 20,
      margin: EdgeInsetsDirectional.only(end: 40.r),
      child: widget.review == null
          ? const SizedBox()
          : Row(
              children: [
                Expanded(
                  child: Text(
                    widget.review!.name,
                    style: themeData.textTheme.titleMedium!.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        height: 24 / 14),
                  ),
                ),
                Text(
                  formatDate(widget.review!.createdAt),
                  style: themeData.textTheme.bodySmall!
                      .copyWith(letterSpacing: 0.2),
                ),
              ],
            ),
    );
  }

  Widget _buildReviewRating(ThemeData themeData) {
    return ShimmerWidget(
      loading: widget.loading,
      height: 12,
      borderRadius: 3,
      margin: EdgeInsetsDirectional.only(end: 60.r),
      child: widget.review == null
          ? const SizedBox()
          : RatingBar(
              ignoreGestures: true,
              initialRating: widget.review!.rating.toDouble(),
              itemSize: 10.r,
              itemPadding: EdgeInsetsDirectional.only(end: 6.r),
              ratingWidget: RatingWidget(
                full: SvgPicture.asset(AppAssetManager.starFilled),
                half: SvgPicture.asset(AppAssetManager.starEmpty),
                empty: SvgPicture.asset(AppAssetManager.starEmpty),
              ),
              onRatingUpdate: (rating) {},
            ),
    );
  }
}
