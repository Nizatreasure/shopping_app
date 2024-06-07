import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
      ),
    ],
  );
}
