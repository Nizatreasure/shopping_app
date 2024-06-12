import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shopping_app/app/cart/presentation/pages/cart_page.dart';
import 'package:shopping_app/app/cart/presentation/pages/order_summary_page.dart';
import 'package:shopping_app/app/discover/presentation/pages/product_details_page.dart';
import 'package:shopping_app/app/discover/presentation/pages/product_filter_page.dart';
import 'package:shopping_app/app/discover/presentation/pages/product_review_page.dart';
import 'package:shopping_app/core/common/widgets/custom_page_transition.dart';
import 'package:shopping_app/main.dart';

import '../../app/discover/presentation/pages/discover_page.dart';

part 'route_names.dart';

//Application routing using [GoRouter] package
class MyAppRouter {
  static GoRouter router = GoRouter(
    navigatorKey: MyApp.navigatorKey,
    routes: [
      GoRoute(
        path: RouteNames.discover,
        name: RouteNames.discover,
        pageBuilder: (context, state) {
          return CustomPageTransition(child: const DiscoverPage());
        },
        routes: [
          GoRoute(
            path: RouteNames.productDetails,
            name: RouteNames.productDetails,
            pageBuilder: (context, state) {
              Map<String, dynamic>? data = state.extra is Map<String, dynamic>
                  ? state.extra as Map<String, dynamic>
                  : null;
              return CustomPageTransition(
                  child: data == null
                      ? const Scaffold()
                      : ProductDetailsPage(
                          documentID: data['document_id'],
                          productID: data['product_id'],
                        ));
            },
          ),
          GoRoute(
            path: RouteNames.productReview,
            name: RouteNames.productReview,
            pageBuilder: (context, state) {
              ProductReviewPageDataModel? data =
                  state.extra is ProductReviewPageDataModel
                      ? state.extra as ProductReviewPageDataModel
                      : null;
              return CustomPageTransition(
                  child: data == null
                      ? const Scaffold()
                      : ProductReviewPage(data: data));
            },
          ),
          GoRoute(
            path: RouteNames.productFilter,
            name: RouteNames.productFilter,
            pageBuilder: (context, state) {
              return CustomPageTransition(child: const ProductFilterPage());
            },
          ),
          GoRoute(
            path: RouteNames.cart,
            name: RouteNames.cart,
            pageBuilder: (context, state) {
              return CustomPageTransition(child: const CartPage());
            },
          ),
          GoRoute(
            path: RouteNames.orderSummary,
            name: RouteNames.orderSummary,
            pageBuilder: (context, state) {
              return CustomPageTransition(child: const OrderSummaryPage());
            },
          ),
        ],
      ),
    ],
  );
}
