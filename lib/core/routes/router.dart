import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shopping_app/app/discover/presentation/pages/product_details_page.dart';
import 'package:shopping_app/app/discover/presentation/pages/product_filter_page.dart';
import 'package:shopping_app/app/discover/presentation/pages/product_review_page.dart';
import 'package:shopping_app/main.dart';

import '../../app/discover/presentation/pages/discover_page.dart';

part 'route_names.dart';

class MyAppRouter {
  static GoRouter router = GoRouter(
    navigatorKey: MyApp.navigatorKey,
    routes: [
      GoRoute(
        path: RouteNames.discover,
        name: RouteNames.discover,
        pageBuilder: (context, state) {
          return const MaterialPage(child: DiscoverPage());
        },
        routes: [
          GoRoute(
            path: RouteNames.productDetails,
            name: RouteNames.productDetails,
            pageBuilder: (context, state) {
              return const MaterialPage(child: ProductDetailsPage());
            },
          ),
          GoRoute(
            path: RouteNames.productReview,
            name: RouteNames.productReview,
            pageBuilder: (context, state) {
              return const MaterialPage(child: ProductReviewPage());
            },
          ),
          GoRoute(
            path: RouteNames.productFilter,
            name: RouteNames.productFilter,
            pageBuilder: (context, state) {
              return const MaterialPage(child: ProductFilterPage());
            },
          ),
        ],
      ),
    ],
  );
}
