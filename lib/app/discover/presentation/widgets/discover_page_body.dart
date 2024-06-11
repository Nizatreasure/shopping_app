import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopping_app/app/discover/data/models/product_model.dart';
import 'package:shopping_app/app/discover/presentation/blocs/discover_bloc/discover_bloc.dart';
import 'package:shopping_app/core/common/enums/enums.dart';
import 'package:shopping_app/core/common/network/data_status.dart';
import 'package:shopping_app/core/common/widgets/error_widget.dart';
import 'package:shopping_app/core/common/widgets/no_product_widget.dart';

import '../pages/discover_page.dart';
import 'shimmer_widget.dart';

class DiscoverPageBody extends StatelessWidget {
  final bool filter;
  final bool loadingBrands;
  const DiscoverPageBody(
      {super.key, this.filter = false, required this.loadingBrands});

  @override
  Widget build(BuildContext context) {
    double bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    return BlocBuilder<DiscoverBloc, DiscoverState>(
      builder: (context, state) {
        DataStatus productStatus = filter
            ? state.filteredProductsStatus
            : state.productTabs[state.tabIndex].status;

        List<ProductModel>? products = filter
            ? state.filteredProducts
            : state.productTabs[state.tabIndex].product;

        bool loadingProducts = productStatus.state == DataState.loading ||
            productStatus.state == DataState.initial ||
            loadingBrands;

        return IgnorePointer(
          ignoring: loadingProducts,
          child: _buildProductList(context, bottomPadding, loadingProducts,
              products, productStatus, state),
        );
      },
    );
  }

  Widget _buildProductList(
      BuildContext context,
      double bottomPadding,
      bool loadingProducts,
      List<ProductModel>? products,
      DataStatus productStatus,
      DiscoverState state) {
    return productStatus.state == DataState.failure
        ? AppErrorWidget(
            errorMessage: productStatus.exception!.message,
            onTap: () {
              DiscoverBloc discoverBloc = context.read<DiscoverBloc>();
              if (filter && state.tabIndex == 0) {
                discoverBloc.add(const DiscoverApplyFilterEvent());
              } else if (state.brandStatus.state == DataState.failure) {
                discoverBloc.add(const DiscoverGetBrandsEvent());
              } else {
                discoverBloc.add(DiscoverGetProductListEvent(state.tabIndex));
              }
            })
        : (products?.isEmpty ?? false)
            ? const AppEmptyDataWidget()
            : GridView.builder(
                key: PageStorageKey('products-${state.tabIndex}'),
                itemCount: filter ? products?.length : null,
                controller: state.tabIndex == 0
                    ? context.read<DiscoverBloc>().allProductsScrollController
                    : null,
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
                    child: products == null
                        ? const SizedBox()
                        : ItemPreviewWidget(
                            item: products[index % products.length],
                          ),
                  );
                },
              );
  }
}
