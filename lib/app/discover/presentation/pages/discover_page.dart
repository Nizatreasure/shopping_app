import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:shopping_app/app/cart/presentation/blocs/cart_bloc/cart_bloc.dart';
import 'package:shopping_app/app/discover/data/models/product_model.dart';
import 'package:shopping_app/app/discover/presentation/blocs/discover_bloc/discover_bloc.dart';
import 'package:shopping_app/app/discover/presentation/widgets/discover_page_body.dart';
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
  DateTime? _currentBackPressTime;
  @override
  void initState() {
    context.read<DiscoverBloc>().add(const DiscoverGetBrandsEvent());
    context.read<CartBloc>().add(const CartGetCartItemsEvent());
    BackButtonInterceptor.add(myInterceptor);
    super.initState();
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    //The path of the topmost route in GoRouter's state
    final String location = GoRouterState.of(context).topRoute!.path;

    //This should only show up if the current route is the base route i.e
    //if the path is "/"
    //
    //The user has to press the back button 2x with 2 seconds in order to close the app
    if (location == '/' &&
        (_currentBackPressTime == null ||
            DateTime.now().difference(_currentBackPressTime!).inSeconds > 2)) {
      _currentBackPressTime = DateTime.now();

      //tell users to press the back button again to close the app
      Fluttertoast.showToast(
        msg: StringManager.pressAgainToCloseApp,
        gravity: ToastGravity.CENTER,
      );
      //true prevents the page from closing
      return true;
    }
    //false allows the page to close
    return false;
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
      body: BlocBuilder<DiscoverBloc, DiscoverState>(
          buildWhen: (previous, current) =>
              previous.brandStatus != current.brandStatus ||
              previous.brands != current.brands,
          builder: (context, state) {
            DataState brandState = state.brandStatus.state;
            bool loadingBrands = brandState == DataState.loading ||
                brandState == DataState.initial;
            int tabLength = loadingBrands ? 1 : state.brands.length;

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
                        child: _buildBody(tabLength, loadingBrands),
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
          }),
    );
  }

  Widget _buildBody(int tabLength, bool loadingBrands) {
    return TabBarView(
      physics: const NeverScrollableScrollPhysics(),
      children: List.generate(tabLength, (index) {
        if (index == 0) {
          return BlocBuilder<DiscoverBloc, DiscoverState>(
              buildWhen: (previous, current) =>
                  previous.isFiltering != current.isFiltering,
              builder: (context, state) {
                return DiscoverPageBody(
                    filter: state.isFiltering, loadingBrands: loadingBrands);
              });
        }
        return DiscoverPageBody(loadingBrands: loadingBrands);
      }),
    );
  }

  Widget _buildTabBar(bool loadingBrands, ThemeData themeData, int tabLength,
      DiscoverState state) {
    return state.brandStatus.state == DataState.failure
        ? const SizedBox()
        : ShimmerWidget(
            numberOfShimmer: 5,
            margin: EdgeInsetsDirectional.symmetric(horizontal: 30.r),
            shimmerSpacing: 10,
            borderRadius: 10,
            loading: loadingBrands,
            child: TabBar(
              onTap: (value) {
                context
                    .read<DiscoverBloc>()
                    .add(DiscoverTabIndexChangedEvent(value));
              },
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
                  text: state.brands[index].name,
                ),
              ),
            ),
          );
  }

  Widget _buildFilterButton(ThemeData themeData) {
    return BlocBuilder<DiscoverBloc, DiscoverState>(
        buildWhen: (previous, current) =>
            previous.productTabs[0].status != current.productTabs[0].status ||
            previous.tabIndex != current.tabIndex ||
            previous.filters != current.filters ||
            previous.isFiltering != current.isFiltering,
        builder: (context, state) {
          return state.tabIndex == 0 &&
                  state.productTabs[0].status.state == DataState.success
              ? AppButtonWidget(
                  height: 40.r,
                  shrinkToFitChildSize: true,
                  padding: EdgeInsetsDirectional.symmetric(horizontal: 20.r),
                  onTap: () => context.pushNamed(RouteNames.productFilter),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          SvgPicture.asset(AppAssetManager.filter),
                          if (state.isFiltering)
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
                )
              : const SizedBox();
        });
  }
}
