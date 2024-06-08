import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:shopping_app/core/common/widgets/appbar_widget.dart';
import 'package:shopping_app/core/common/widgets/cart_widget.dart';
import 'package:shopping_app/core/values/asset_manager.dart';
import 'package:shopping_app/core/values/color_manager.dart';
import 'package:shopping_app/core/values/string_manager.dart';
import 'package:shopping_app/globals.dart';

part '../widgets/product_details_image_display_widget.dart';
part '../widgets/product_details_size_widget.dart';

class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      appBar: appbarWidget(
        context,
        title: '',
        actions: [const CartWidget()],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsetsDirectional.fromSTEB(
                  30.r, 10.r, 30.r, MediaQuery.of(context).viewPadding.bottom),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ProductDetailsImageDisplayWidget(),
                  SizedBox(height: 30.r),
                  _buildProductNameAndRating(themeData),
                  SizedBox(height: 30.r),
                  const ProductDetailsSizeWidget(),
                  SizedBox(height: 30.r),
                  _buildProductDescription(themeData),
                  SizedBox(height: 30.r),
                  _buildReviews(themeData),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductNameAndRating(ThemeData themeData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Jordan 1 Retro High Tie Dye',
          style: themeData.textTheme.headlineMedium!.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            height: 30 / 20,
          ),
        ),
        SizedBox(height: 10.r),
        Row(
          children: [
            RatingBar(
              ratingWidget: RatingWidget(
                  full: SvgPicture.asset(AppAssetManager.starFilled),
                  half: SvgPicture.asset(AppAssetManager.starEmpty),
                  empty: SvgPicture.asset(AppAssetManager.starEmpty)),
              onRatingUpdate: (rating) {},
              initialRating: 4.5,
              itemSize: 12.r,
              itemPadding: EdgeInsetsDirectional.only(end: 5.r),
              ignoreGestures: true,
            ),
            Text(
              Globals.ratingFormat.format(4.5),
              style: themeData.textTheme.headlineMedium!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
            SizedBox(width: 5.r),
            Text(
              '(${'0'} ${StringManager.reviews})',
              style: themeData.textTheme.headlineMedium!.copyWith(
                fontWeight: FontWeight.normal,
                fontSize: 11,
                color: ColorManager.primaryLight300,
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildProductDescription(ThemeData themeData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          StringManager.description,
          style: themeData.textTheme.titleLarge!.copyWith(
              fontSize: 16, fontWeight: FontWeight.w600, height: 26 / 16),
        ),
        SizedBox(height: 10.r),
        Text(
          'Engineered to crush any movement-based workout, these On sneakers enhance the label‘s original Cloud sneaker with cutting edge technologies for a pair.',
          style: themeData.textTheme.bodyMedium!
              .copyWith(height: 24 / 14, color: ColorManager.primaryLight400),
        )
      ],
    );
  }

  Widget _buildReviews(ThemeData themeData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${StringManager.review} (1045)',
          style: themeData.textTheme.titleLarge!.copyWith(
              fontSize: 16, fontWeight: FontWeight.w600, height: 26 / 16),
        ),
        SizedBox(height: 10.r),
      ],
    );
  }
}
