import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopping_app/app/cart/data/models/cart_model.dart';
import 'package:shopping_app/blocs.dart';
import 'package:shopping_app/core/constants/constants.dart';
import 'package:shopping_app/di.dart';
import 'package:shopping_app/globals.dart';

import 'app/cart/data/repositories/cart_repository_impl.dart';
import 'app/discover/data/models/product_model.dart';
import 'core/routes/router.dart';
import 'core/values/theme_manager.dart';

void main() async {
  await Globals.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static final navigatorKey = GlobalKey<NavigatorState>();
  const MyApp._internal();

  static const MyApp instance = MyApp._internal();

  factory MyApp() => instance;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<String> adidas = [
    "https://firebasestorage.googleapis.com/v0/b/shopping-app-38f32.appspot.com/o/images%2Fadidas.png?alt=media&token=a0a3c523-f760-47f3-b52f-75e713523b78",
    "https://firebasestorage.googleapis.com/v0/b/shopping-app-38f32.appspot.com/o/images%2Fadidas2.png?alt=media&token=4747901b-5c6b-4dd9-8a9c-73036059ad21",
    "https://firebasestorage.googleapis.com/v0/b/shopping-app-38f32.appspot.com/o/images%2Fadidas3.png?alt=media&token=a3f90a89-ffce-4a36-b987-ddd6c7d17451",
  ];
  List<String> puma = [
    "https://firebasestorage.googleapis.com/v0/b/shopping-app-38f32.appspot.com/o/images%2Fpuma.png?alt=media&token=bddf76e1-af5b-425c-bd00-1bc7d6738b64",
    "https://firebasestorage.googleapis.com/v0/b/shopping-app-38f32.appspot.com/o/images%2Fpuma2.png?alt=media&token=47cb9e6d-22a9-4e16-8d2f-c7bac4b7de47",
    "https://firebasestorage.googleapis.com/v0/b/shopping-app-38f32.appspot.com/o/images%2Fpuma3.png?alt=media&token=a658aa86-cbe7-442e-82f6-ec048d735d6e",
  ];
  List<String> vans = [
    "https://firebasestorage.googleapis.com/v0/b/shopping-app-38f32.appspot.com/o/images%2Fvans-black.png?alt=media&token=358b5de9-4a6b-4557-b636-dc89c367d275",
    "https://firebasestorage.googleapis.com/v0/b/shopping-app-38f32.appspot.com/o/images%2Fvans-black2.png?alt=media&token=5daf245e-733e-478c-be1c-5f7fa3f97302",
    "https://firebasestorage.googleapis.com/v0/b/shopping-app-38f32.appspot.com/o/images%2Fvans-black3.png?alt=media&token=591b92bd-50cb-4ee7-86d6-c025985aa9e1",
  ];
  List<String> reebok = [
    "https://firebasestorage.googleapis.com/v0/b/shopping-app-38f32.appspot.com/o/images%2Freebok.png?alt=media&token=23d1e448-d59e-487b-97b7-66d59617a1f6",
    "https://firebasestorage.googleapis.com/v0/b/shopping-app-38f32.appspot.com/o/images%2Freebok2.png?alt=media&token=a21756d3-324a-4153-ad04-f1e4cb9b59bc",
    "https://firebasestorage.googleapis.com/v0/b/shopping-app-38f32.appspot.com/o/images%2Freebok3.png?alt=media&token=375e6fa7-3ab9-4cc5-8204-cb0c6b13744e",
    "https://firebasestorage.googleapis.com/v0/b/shopping-app-38f32.appspot.com/o/images%2Freebok4.png?alt=media&token=2220195c-62f7-4fd4-b81d-1f8965d764ef",
  ];
  List<String> jordan = [
    "https://firebasestorage.googleapis.com/v0/b/shopping-app-38f32.appspot.com/o/images%2Fjordan.png?alt=media&token=6cb40f53-b962-4a78-b702-bd060cfc18e5",
    "https://firebasestorage.googleapis.com/v0/b/shopping-app-38f32.appspot.com/o/images%2Fjordan2.png?alt=media&token=10fdb8ad-e93f-4746-8ef7-7d9243acd11d",
    "https://firebasestorage.googleapis.com/v0/b/shopping-app-38f32.appspot.com/o/images%2Fjordan3.png?alt=media&token=6d57a9d8-e936-43c6-ae6d-cc446d171c2c",
    "https://firebasestorage.googleapis.com/v0/b/shopping-app-38f32.appspot.com/o/images%2Fjordan4.png?alt=media&token=be173246-9d60-479f-87a6-2ab65f89790a",
  ];
  List<String> nike = [
    "https://firebasestorage.googleapis.com/v0/b/shopping-app-38f32.appspot.com/o/images%2Fnike.png?alt=media&token=41f4355b-8ba1-4cfe-bbff-4b48e6e87ea0",
    "https://firebasestorage.googleapis.com/v0/b/shopping-app-38f32.appspot.com/o/images%2Fnike2.png?alt=media&token=ea599986-ef42-41c9-9d54-aae418896b0a",
    "https://firebasestorage.googleapis.com/v0/b/shopping-app-38f32.appspot.com/o/images%2Fnike3.png?alt=media&token=23d6f747-1633-4242-a05a-506c2043b3b2",
  ];

  @override
  void initState() {
    super.initState();
  }

  String brandName = 'Vans';

  List<String> getImagesFromBrand(String name) {
    switch (name.toLowerCase()) {
      case 'adidas':
        return adidas;
      case 'puma':
        return puma;
      case 'vans':
        return vans;
      case 'reebok':
        return reebok;
      case 'jordan':
        return jordan;
      default:
        return nike;
    }
  }

  getData() async {
    await getIt<CartRepository>().addProductToCart(CartModel(
      id: 0,
      docID: 'docID',
      productName: 'productName',
      brandName: brandName,
      color: 'color',
      size: 23,
      price: PriceModel(amount: 200, currency: 'USD', symbol: r'$'),
      quantity: 2,
      imageUrl: 'imageUrl',
      productID: 0,
      productDocumentID: 'productDocumentID',
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: MultiBlocProvider(
            providers: AppBlocs.blocs,
            child: MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: AppConstants.appTitle,
              routeInformationParser: MyAppRouter.router.routeInformationParser,
              routerDelegate: MyAppRouter.router.routerDelegate,
              routeInformationProvider:
                  MyAppRouter.router.routeInformationProvider,
              theme: ThemeManager.getLightTheme(),
              builder: (context, child) {
                return ScrollConfiguration(
                  behavior: const ScrollBehavior().copyWith(overscroll: false),
                  child: child!,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
