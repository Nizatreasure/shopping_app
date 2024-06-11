import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shopping_app/app/discover/data/models/product_model.dart';
import 'package:shopping_app/app/discover/data/models/product_review_model.dart';
import 'package:shopping_app/app/discover/presentation/blocs/product_review_bloc/product_review_bloc.dart';
import 'package:shopping_app/app/discover/presentation/widgets/product_review_widget.dart';
import 'package:shopping_app/core/common/widgets/appbar_widget.dart';
import 'package:shopping_app/core/common/widgets/error_widget.dart';
import 'package:shopping_app/core/common/widgets/no_product_widget.dart';
import 'package:shopping_app/core/constants/constants.dart';
import 'package:shopping_app/core/values/asset_manager.dart';
import 'package:shopping_app/core/values/color_manager.dart';
import 'package:shopping_app/core/values/string_manager.dart';
import 'package:shopping_app/di.dart';
import 'package:shopping_app/globals.dart';

class ProductReviewPage extends StatefulWidget {
  final ProductReviewPageDataModel data;
  const ProductReviewPage({super.key, required this.data});

  @override
  State<ProductReviewPage> createState() => _ProductReviewPageState();
}

class _ProductReviewPageState extends State<ProductReviewPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    _tabController =
        TabController(length: AppConstants.reviewTabLength, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    double bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    return BlocProvider<ProductReviewBloc>(
      create: (context) =>
          getIt()..add(ProductReviewSetProductIdEvent(widget.data.productID)),
      child: Scaffold(
        appBar: appbarWidget(
          context,
          title:
              '${StringManager.review} (${widget.data.reviewInfo.totalReviews})',
          actions: [
            _appBarActionWidget(themeData),
          ],
        ),
        body: Builder(builder: (context) {
          return Column(
            children: [
              SizedBox(height: 12.r),
              _buildTabs(context, themeData),
              SizedBox(height: 20.r),
              Expanded(
                child: _buildProductReviews(context, bottomPadding),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildProductReviews(BuildContext context, double bottomPadding) {
    return BlocBuilder<ProductReviewBloc, ProductReviewState>(
        builder: (context, state) {
      ProductReviewTabModel reviewTab = state.reviews[state.tabIndex];
      return reviewTab.loadingError
          ? AppErrorWidget(
              errorMessage: reviewTab.status.exception!.message,
              onTap: () {
                context
                    .read<ProductReviewBloc>()
                    .add(ProductReviewGetReviewEvent(state.tabIndex));
              },
            )
          : reviewTab.reviews?.isEmpty ?? false
              ? const AppEmptyDataWidget(
                  text: StringManager.noReview, isReview: true)
              : IgnorePointer(
                  ignoring: state.reviews[state.tabIndex].loading,
                  child: ListView.builder(
                    itemCount: state.reviews[state.tabIndex].reviews?.length,
                    padding: EdgeInsetsDirectional.fromSTEB(
                        30.r, 0, 30.r, bottomPadding),
                    itemBuilder: (context, index) {
                      return ProductReviewWidget(
                        review: reviewTab.reviews?[index],
                        loading: reviewTab.loading,
                      );
                    },
                  ),
                );
    });
  }

  Widget _appBarActionWidget(ThemeData themeData) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SvgPicture.asset(AppAssetManager.starFilled, width: 20.r, height: 20.r),
        SizedBox(width: 5.r),
        Text(
          Globals.ratingFormat.format(widget.data.reviewInfo.averageRating),
          style: themeData.textTheme.titleLarge!.copyWith(
            height: 20 / 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTabs(BuildContext context, ThemeData themeData) {
    return BlocBuilder<ProductReviewBloc, ProductReviewState>(
        buildWhen: (previous, current) => previous.tabIndex != current.tabIndex,
        builder: (context, state) {
          return TabBar(
            controller: _tabController,
            indicatorColor: ColorManager.transparent,
            dividerColor: ColorManager.transparent,
            labelStyle: themeData.textTheme.headlineMedium!
                .copyWith(fontSize: 20, height: 30 / 20),
            unselectedLabelColor: ColorManager.primaryLight300,
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            isScrollable: true,
            labelPadding: EdgeInsets.symmetric(horizontal: 10.r),
            padding: EdgeInsetsDirectional.symmetric(
                horizontal: 30.r - kTabLabelPadding.left),
            tabAlignment: TabAlignment.start,
            onTap: (index) => context
                .read<ProductReviewBloc>()
                .add(ProductReviewChangeTabIndexEvent(index)),
            tabs: List.generate(
              state.reviews.length,
              (index) => Tab(text: state.reviews[index].tabTitle),
            ),
          );
        });
  }
}

class ProductReviewPageDataModel {
  final ReviewInfoModel reviewInfo;
  final int productID;
  const ProductReviewPageDataModel({
    required this.reviewInfo,
    required this.productID,
  });
}
