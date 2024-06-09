import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shopping_app/app/discover/data/models/product_model.dart';
import 'package:shopping_app/app/discover/presentation/blocs/discover_bloc/discover_bloc.dart';
import 'package:shopping_app/app/discover/presentation/widgets/shimmer_widget.dart';
import 'package:shopping_app/core/common/enums/enums.dart';
import 'package:shopping_app/core/common/widgets/app_button_widget.dart';
import 'package:shopping_app/core/common/widgets/appbar_widget.dart';
import 'package:shopping_app/core/common/widgets/cart_widget.dart';
import 'package:shopping_app/core/common/widgets/custom_network_image.dart';
import 'package:shopping_app/core/routes/router.dart';
import 'package:shopping_app/core/values/asset_manager.dart';
import 'package:shopping_app/core/values/color_manager.dart';
import 'package:shopping_app/core/values/string_manager.dart';
import 'package:shopping_app/globals.dart';

part '../widgets/item_preview_widget.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  @override
  void initState() {
    context.read<DiscoverBloc>()
      ..add(const DiscoverGetBrandsEvent())
      ..add(const DiscoverGetProductListEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    double bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    return Scaffold(
      appBar: appbarWidget(
        context,
        title: StringManager.discover,
        largeTitle: true,
        centerTitle: false,
        showBackButton: false,
        toolbarAdditionalHeight: 20,
        titleSpacing: 30.r,
        actions: [const CartWidget()],
      ),
      body: BlocBuilder<DiscoverBloc, DiscoverState>(builder: (context, state) {
        return _buildBody(themeData, bottomPadding, state);
      }),
    );
  }

  Widget _buildBody(
      ThemeData themeData, double bottomPadding, DiscoverState state) {
    DataState brandState = state.brandStatus.state;
    DataState productState = state.productStatus.state;
    bool loadingBrands =
        brandState == DataState.loading || brandState == DataState.initial;
    bool loadingProducts = productState == DataState.loading ||
        productState == DataState.initial ||
        loadingBrands;
    int tabLength =
        state.brands == null || loadingBrands ? 1 : state.brands!.length + 1;

    return DefaultTabController(
      length: tabLength,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTabBar(loadingBrands, themeData, tabLength, state),
              Expanded(
                child: IgnorePointer(
                  ignoring: loadingProducts,
                  child:
                      _buildProductList(bottomPadding, loadingProducts, state),
                ),
              )
            ],
          ),
          Positioned(
            bottom: bottomPadding + 20.r,
            child: _buildFilterButton(themeData),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList(
      double bottomPadding, bool loadingProducts, DiscoverState state) {
    return state.brandStatus.state == DataState.failure
        ? Container()
        : (state.products?.isEmpty ?? false)
            ? const Align(
                alignment: Alignment(0, -0.2),
                child: Text(
                  'No products',
                ),
              )
            : GridView.builder(
                itemCount: 20,
                padding: EdgeInsetsDirectional.fromSTEB(
                    30.r, 15.r, 30.r, 70.r + bottomPadding),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: loadingProducts ? 150.r : 225.r,
                  crossAxisSpacing: 15.r,
                  mainAxisSpacing: 30.r,
                ),
                itemBuilder: (context, index) {
                  return ShimmerWidget(
                    loading: loadingProducts,
                    child: state.products == null
                        ? const SizedBox()
                        : ItemPreviewWidget(
                            item:
                                state.products![index % state.products!.length],
                          ),
                  );
                },
              );
  }

  Widget _buildTabBar(
      bool loading, ThemeData themeData, int tabLength, DiscoverState state) {
    //Do not show the tabs if brands could not be fetched
    //from the firebase
    return state.brandStatus.state == DataState.failure
        ? const SizedBox()
        : ShimmerWidget(
            numberOfShimmerInRow: 5,
            margin: EdgeInsetsDirectional.symmetric(horizontal: 30.r),
            shimmerSpacing: 10,
            borderRadius: 10,
            loading: loading,
            child: TabBar(
              indicatorColor: ColorManager.transparent,
              dividerColor: ColorManager.transparent,
              labelStyle: themeData.textTheme.headlineMedium!
                  .copyWith(fontSize: 20, height: 30 / 20),
              unselectedLabelColor: ColorManager.primaryLight300,
              overlayColor: const WidgetStatePropertyAll(Colors.transparent),
              isScrollable: true,
              labelPadding: EdgeInsets.symmetric(horizontal: 10.r),
              padding: EdgeInsetsDirectional.symmetric(horizontal: 30.r - 10.r),
              tabAlignment: TabAlignment.start,
              tabs: List.generate(
                tabLength,
                (index) => Tab(
                  text: index == 0
                      ? StringManager.all
                      : state.brands![index - 1].name,
                ),
              ),
            ),
          );
  }

  Widget _buildFilterButton(ThemeData themeData) {
    return AppButtonWidget(
      height: 40.r,
      shrinkToFitChildSize: true,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 20.r),
      onTap: () => context.pushNamed(RouteNames.productFilter),
      child: Row(
        children: [
          Stack(
            children: [
              SvgPicture.asset(AppAssetManager.filter),
              PositionedDirectional(
                end: 0,
                child: CircleAvatar(
                  radius: 4.r,
                  backgroundColor: ColorManager.errorDefault500,
                ),
              )
            ],
          ),
          SizedBox(width: 16.r),
          Text(
            StringManager.filter.toUpperCase(),
            style: themeData.textTheme.titleMedium!.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: ColorManager.white,
            ),
          )
        ],
      ),
    );
  }
}
