import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shopping_app/app/discover/data/models/product_model.dart';
import 'package:shopping_app/app/discover/presentation/blocs/product_details_bloc/product_details_bloc.dart';
import 'package:shopping_app/app/discover/presentation/pages/product_review_page.dart';
import 'package:shopping_app/app/discover/presentation/widgets/add_to_cart_modal.dart';
import 'package:shopping_app/app/discover/presentation/widgets/added_to_cart_modal.dart';
import 'package:shopping_app/app/discover/presentation/widgets/product_review_widget.dart';
import 'package:shopping_app/app/discover/presentation/widgets/shimmer_widget.dart';
import 'package:shopping_app/core/common/enums/enums.dart';
import 'package:shopping_app/core/common/widgets/app_button_widget.dart';
import 'package:shopping_app/core/common/widgets/app_snackbar.dart';
import 'package:shopping_app/core/common/widgets/appbar_widget.dart';
import 'package:shopping_app/core/common/widgets/cart_widget.dart';
import 'package:shopping_app/core/common/widgets/custom_network_image.dart';
import 'package:shopping_app/core/common/widgets/error_widget.dart';
import 'package:shopping_app/core/routes/router.dart';
import 'package:shopping_app/core/values/asset_manager.dart';
import 'package:shopping_app/core/values/color_manager.dart';
import 'package:shopping_app/core/values/string_manager.dart';
import 'package:shopping_app/di.dart';
import 'package:shopping_app/globals.dart';

part '../widgets/product_details_image_display_widget.dart';
part '../widgets/product_details_size_widget.dart';

class ProductDetailsPage extends StatelessWidget {
  final String documentID;
  final int productID;
  const ProductDetailsPage(
      {super.key, required this.documentID, required this.productID});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    double bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    return BlocProvider<ProductDetailsBloc>(
      create: (context) => getIt()
        ..add(ProductDetailsGetProductDetailsEvent(documentID))
        ..add(ProductDetailsGetTopThreeReviewsEvent(productID)),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: appbarWidget(
          context,
          title: '',
          actions: [const CartWidget()],
        ),
        body: Builder(builder: (context) {
          return BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
              buildWhen: (previous, current) =>
                  previous.productStatus.state != current.productStatus.state ||
                  previous.reviewStatus.state != current.reviewStatus.state,
              builder: (context, detailsState) {
                if (detailsState.loadingError) {
                  return _loadingErrorWidget(detailsState, context);
                }
                return _buildBody(context, themeData, bottomPadding);
              });
        }),
      ),
    );
  }

  Widget _loadingErrorWidget(ProductDetailsState state, BuildContext context) {
    return AppErrorWidget(
        errorMessage: state.productStatus.exception?.message ??
            state.reviewStatus.exception!.message,
        onTap: () {
          context.read<ProductDetailsBloc>()
            ..add(ProductDetailsGetProductDetailsEvent(documentID))
            ..add(ProductDetailsGetTopThreeReviewsEvent(productID));
        });
  }

  Widget _buildBody(
      BuildContext context, ThemeData themeData, double bottomPadding) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsetsDirectional.fromSTEB(30.r, 10.r, 30.r,
                MediaQuery.of(context).viewPadding.bottom + 30.r),
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
                _buildReviews(context, themeData),
              ],
            ),
          ),
        ),
        _buildBottomPageWidget(context, themeData, bottomPadding),
      ],
    );
  }

  Widget _buildBottomPageWidget(
      BuildContext context, ThemeData themeData, double bottomPadding) {
    return BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
        builder: (context, state) {
      return state.productStatus.state == DataState.success &&
              state.reviewStatus.state == DataState.success &&
              state.productDetails != null
          ? Container(
              height: 90.r + bottomPadding,
              decoration: BoxDecoration(
                color: ColorManager.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 30.r,
                    spreadRadius: 0,
                    color: ColorManager.lightGrey.withOpacity(0.2),
                    offset: const Offset(0, -20),
                  )
                ],
              ),
              alignment: Alignment.topCenter,
              padding: EdgeInsetsDirectional.symmetric(
                  horizontal: 30.r, vertical: 20.r),
              child: SizedBox(
                height: 57.r,
                child: Row(
                  children: [
                    Expanded(
                      child: _productPriceDetailsWidget(themeData, state),
                    ),
                    AppButtonWidget(
                      text: StringManager.addToCart.toUpperCase(),
                      shrinkToFitChildSize: true,
                      padding:
                          EdgeInsetsDirectional.symmetric(horizontal: 31.5.r),
                      onTap: () async {
                        if (state.selectedColor == null) {
                          showAppMaterialBanner(context,
                              text: 'Please select a product color');
                          return;
                        }
                        if (state.selectedSize == null) {
                          showAppMaterialBanner(context,
                              text: 'Please select a product size');
                          return;
                        }
                        bool success = await addToCart(context);
                        if (success && context.mounted) {
                          addedToCart(context);
                        }
                      },
                    )
                  ],
                ),
              ),
            )
          : const SizedBox();
    });
  }

  Widget _productPriceDetailsWidget(
      ThemeData themeData, ProductDetailsState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          StringManager.price,
          style: themeData.textTheme.bodySmall!
              .copyWith(height: 22 / 12, color: ColorManager.primaryLight300),
        ),
        Text(
          '${state.productDetails!.price.symbol}${Globals.amountFormat.format(state.productDetails!.price.amount)}',
          style: themeData.textTheme.headlineMedium!.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            height: 30 / 20,
          ),
        )
      ],
    );
  }

  Widget _buildProductNameAndRating(ThemeData themeData) {
    return BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
        buildWhen: (previous, current) =>
            previous.productStatus != current.productStatus ||
            previous.productDetails != current.productDetails ||
            previous.reviewStatus != current.reviewStatus,
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerWidget(
                loading: state.loading,
                borderRadius: 3,
                margin: EdgeInsetsDirectional.only(end: 80.r),
                child: state.productDetails == null
                    ? const SizedBox()
                    : Text(
                        state.productDetails!.name,
                        style: themeData.textTheme.headlineMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          height: 30 / 20,
                        ),
                      ),
              ),
              SizedBox(height: 10.r),
              ShimmerWidget(
                loading: state.loading,
                margin: EdgeInsetsDirectional.only(end: 120.r),
                height: 25,
                borderRadius: 3,
                child: state.productDetails == null
                    ? const SizedBox()
                    : Row(
                        children: [
                          RatingBar(
                            ratingWidget: RatingWidget(
                                full: SvgPicture.asset(
                                    AppAssetManager.starFilled),
                                half:
                                    SvgPicture.asset(AppAssetManager.starEmpty),
                                empty: SvgPicture.asset(
                                    AppAssetManager.starEmpty)),
                            onRatingUpdate: (rating) {},
                            initialRating:
                                state.productDetails!.reviewInfo.averageRating,
                            itemSize: 12.r,
                            itemPadding: EdgeInsetsDirectional.only(end: 5.r),
                            ignoreGestures: true,
                          ),
                          Text(
                            Globals.ratingFormat.format(
                                state.productDetails!.reviewInfo.averageRating),
                            style: themeData.textTheme.headlineMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                          SizedBox(width: 5.r),
                          Text(
                            '(${state.productDetails!.reviewInfo.totalReviews} ${StringManager.reviews})',
                            style: themeData.textTheme.headlineMedium!.copyWith(
                              fontWeight: FontWeight.normal,
                              fontSize: 11,
                              color: ColorManager.primaryLight300,
                            ),
                          )
                        ],
                      ),
              ),
            ],
          );
        });
  }

  Widget _buildProductDescription(ThemeData themeData) {
    return BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
        buildWhen: (previous, current) =>
            previous.productStatus != current.productStatus ||
            previous.productDetails != current.productDetails ||
            previous.reviewStatus != current.reviewStatus,
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerWidget(
                loading: state.loading,
                borderRadius: 3,
                margin: EdgeInsetsDirectional.only(end: 80.r),
                child: state.productDetails == null
                    ? const SizedBox()
                    : Text(
                        StringManager.description,
                        style: themeData.textTheme.titleLarge!.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 26 / 16),
                      ),
              ),
              SizedBox(height: 10.r),
              ShimmerWidget(
                loading: state.loading,
                borderRadius: 3,
                height: 120,
                child: state.productDetails == null
                    ? const SizedBox()
                    : Text(
                        state.productDetails!.description,
                        style: themeData.textTheme.bodyMedium!.copyWith(
                            height: 24 / 14,
                            color: ColorManager.primaryLight400),
                      ),
              )
            ],
          );
        });
  }

  Widget _buildReviews(BuildContext context, ThemeData themeData) {
    return BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
        buildWhen: (previous, current) =>
            previous.productStatus != current.productStatus ||
            previous.productDetails != current.productDetails ||
            previous.reviewStatus != current.reviewStatus ||
            previous.productReviews != current.productReviews,
        builder: (context, state) {
          bool loading = state.loading;
          return state.productReviews?.isEmpty ?? false
              ? const SizedBox()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _reviewTitleWidget(loading, state, themeData),
                    SizedBox(height: 10.r),
                    ShimmerWidget(
                      loading: loading,
                      height: 100,
                      numberOfShimmer: 4,
                      axis: Axis.vertical,
                      shimmerSpacing: 20,
                      borderRadius: 10,
                      child: state.productDetails == null ||
                              state.productReviews == null
                          ? const SizedBox()
                          : _reviewColumnWidget(state, loading, context),
                    ),
                  ],
                );
        });
  }

  Widget _reviewColumnWidget(
      ProductDetailsState state, bool loading, BuildContext context) {
    return Column(
      children: [
        Builder(builder: (context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(state.productReviews?.length ?? 3, (index) {
              return ProductReviewWidget(
                  review: state.productReviews?[index], loading: loading);
            }),
          );
        }),
        _buildSeeAllReviewButton(context, state),
      ],
    );
  }

  Widget _buildSeeAllReviewButton(
      BuildContext context, ProductDetailsState state) {
    return AppButtonWidget(
      text: StringManager.seeAllReview.toUpperCase(),
      backgroundColor: ColorManager.transparent,
      borderColor: ColorManager.primaryLight200,
      textColor: ColorManager.primaryDefault500,
      onTap: () {
        context.pushNamed(
          RouteNames.productReview,
          extra: ProductReviewPageDataModel(
            productID: state.productDetails!.id,
            reviewInfo: state.productDetails!.reviewInfo,
          ),
        );
      },
    );
  }

  Widget _reviewTitleWidget(
      bool loading, ProductDetailsState state, ThemeData themeData) {
    return ShimmerWidget(
      loading: loading,
      borderRadius: 3,
      margin: EdgeInsetsDirectional.only(end: 80.r),
      child: state.productDetails == null || state.productReviews == null
          ? const SizedBox()
          : Text(
              '${StringManager.review} (${state.productDetails!.reviewInfo.totalReviews})',
              style: themeData.textTheme.titleLarge!.copyWith(
                  fontSize: 16, fontWeight: FontWeight.w600, height: 26 / 16),
            ),
    );
  }

  Future<bool> addToCart(BuildContext context) async {
    ProductDetailsBloc bloc = context.read<ProductDetailsBloc>();
    bool? successful = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height -
              MediaQuery.of(context).viewPadding.top -
              20.r),
      builder: (context) {
        return AddToCartModal(bloc: bloc);
      },
    );
    return successful == true;
  }

  void addedToCart(BuildContext context) async {
    //using a completer so to wait while the bloc executes
    //the transaction
    //a boolean complete is used to listen if the operation was
    //successful or not
    Completer<bool> completer = Completer<bool>();
    context
        .read<ProductDetailsBloc>()
        .add(ProductDetailsAddProductToCartEvent(completer));
    bool success = await completer.future;
    if (success && context.mounted) {
      showModalBottomSheet(
          context: context, builder: (context) => const AddedToCartModal());
    } else if (context.mounted) {
      showAppMaterialBanner(context, text: 'Failed to add product to cart');
    }
  }
}
