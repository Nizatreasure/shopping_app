import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopping_app/app/discover/data/models/product_model.dart';
import 'package:shopping_app/app/discover/presentation/blocs/discover_bloc/discover_bloc.dart';
import 'package:shopping_app/core/common/enums/enums.dart';

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
        DataState productState = filter
            ? state.filteredProductsStatus.state
            : state.productTabs[state.tabIndex].status.state;
        List<ProductModel>? products = filter
            ? state.filteredProducts
            : state.productTabs[state.tabIndex].product;

        bool loadingProducts = productState == DataState.loading ||
            productState == DataState.initial ||
            loadingBrands;

        return IgnorePointer(
          ignoring: loadingProducts,
          child: _buildProductList(
              bottomPadding, loadingProducts, products, productState, state),
        );
      },
    );
  }

  Widget _buildProductList(
      double bottomPadding,
      bool loadingProducts,
      List<ProductModel>? products,
      DataState productState,
      DiscoverState state) {
    return productState == DataState.failure
        ? Container()
        : (products?.isEmpty ?? false)
            ? const Align(
                alignment: Alignment(0, -0.2),
                child: Text(
                  'No products',
                ),
              )
            : GridView.builder(
                key: PageStorageKey('products-${state.tabIndex}'),
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
