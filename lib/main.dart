import 'dart:developer';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopping_app/app/discover/data/data_sources/remote/api_service.dart';
import 'package:shopping_app/app/discover/data/models/brands_model.dart';
import 'package:shopping_app/app/discover/data/repositories/discover_repository_impl.dart';
import 'package:shopping_app/blocs.dart';
import 'package:shopping_app/core/constants/constants.dart';
import 'package:shopping_app/di.dart';
import 'package:shopping_app/globals.dart';

import 'app/discover/data/models/product_model.dart';
import 'app/discover/domain/usecases/usecases.dart';
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
  List<num> numList = [
    39,
    39.5,
    40,
    40.5,
    41,
    41.5,
    42,
    42.5,
    43,
    43.5,
    44,
    44.5,
    45,
    46,
    47
  ];

  List<Map<String, dynamic>> colorList = [
    {"hex": "#FFFFFF", "name": "White"},
    {"hex": "#FF0000", "name": "Red"},
    {"hex": "#00FF00", "name": "Green"},
    {"hex": "#000000", "name": "Black"},
    {"hex": "#A52A2A", "name": "Brown"},
  ];

  @override
  void initState() {
    // getData();
    super.initState();
  }

  getData() async {
    // numList.shuffle();
    // colorList.shuffle();
    // Map<String, dynamic> json = {
    //   "gender": "Unisex",
    //   "id": 18,
    //   "name": "Fusion Flexwave",
    //   "brand": "Reebok",
    //   "description":
    //       "Introducing the Reebok Fusion Flexwave, where innovation meets style for the ultimate performance experience. Designed for athletes who demand both comfort and agility, these shoes feature Flexweave technology that provides flexible support and breathability. The Fusion Flexwave midsole offers responsive cushioning for a smooth ride, while the durable rubber outsole ensures traction and stability on any surface. Whether you're hitting the gym or pounding the pavement, the Reebok Fusion Flexwave is your go-to choice for conquering your fitness goals with confidence and style.",
    //   "images": [
    //     "https://firebasestorage.googleapis.com/v0/b/shopping-app-38f32.appspot.com/o/images%2Freebok3.jpeg?alt=media&token=e0d8b570-7490-4751-ac20-747742e40052",
    //     // "https://firebasestorage.googleapis.com/v0/b/shopping-app-38f32.appspot.com/o/images%2Freebok2.jpeg?alt=media&token=4ef88dca-a36b-4779-a10d-d8849e2d8183",
    //     "https://firebasestorage.googleapis.com/v0/b/shopping-app-38f32.appspot.com/o/images%2Freebok4.jpeg?alt=media&token=53fdabb9-12fd-47a0-950b-6c5c734a4bb9",
    //     "https://firebasestorage.googleapis.com/v0/b/shopping-app-38f32.appspot.com/o/images%2Freebok.jpeg?alt=media&token=f58a9a6a-f6b0-476b-a9e4-4809bcffe7af",
    //   ],

    //   //
    //   "created_at": Timestamp.now(),
    //   "price": {
    //     "amount": Random().nextInt(200) + 170,
    //     "currency": "USD",
    //     "symbol": r"$"
    //   },
    //   "review_info": {"total_reviews": 1, "average_rating": 4.5},
    //   "sizes":
    //       List.generate(Random().nextInt(5) + 2, (index) => numList[index]),
    //   "colors":
    //       List.generate(Random().nextInt(3) + 2, (index) => colorList[index])
    // };
    try {
      final fd = await getIt<DiscoverApiService>().getProductList('');
      // if (fd.isRight) {
      //   print(fd);
      //   List<BrandsModel> mdk = fd.right.docs.map((val) => val.data()).toList();
      // } else {
      //   print('errorr message is ${fd.left.message}');
      // }

      // return;
      // QuerySnapshot data = await getIt<FirebaseFirestore>()
      //     .collection('products')
      //     .where('brand', isEqualTo: 'Vans')
      //     // .orderBy('name')
      //     // .startAfter([''])
      //     // .limit(2)
      //     .get();

      for (DocumentSnapshot<ProductModel> item in fd.docs) {
        print('name is this ${item.data()?.id}');
      }
    } catch (e) {
      print(e);
    }
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
