import 'dart:developer';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopping_app/app/discover/data/data_sources/remote/api_service.dart';
import 'package:shopping_app/app/discover/data/models/brands_model.dart';
import 'package:shopping_app/app/discover/data/models/filter_model.dart';
import 'package:shopping_app/app/discover/data/repositories/discover_repository_impl.dart';
import 'package:shopping_app/blocs.dart';
import 'package:shopping_app/core/common/enums/enums.dart';
import 'package:shopping_app/core/constants/constants.dart';
import 'package:shopping_app/core/values/string_manager.dart';
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
  List<String> imageList = [
    "https://firebasestorage.googleapis.com/v0/b/shopping-app-38f32.appspot.com/o/images%2Fpicture.jpeg?alt=media&token=852b25a2-2422-4c7b-82ce-a53091c53ad1",
    "https://firebasestorage.googleapis.com/v0/b/shopping-app-38f32.appspot.com/o/images%2Fpicture10.jpeg?alt=media&token=c8a6965f-6a7b-4dad-999d-ff922a6bcf30",
    "https://firebasestorage.googleapis.com/v0/b/shopping-app-38f32.appspot.com/o/images%2Fpicture2.jpeg?alt=media&token=3071ab09-da0f-4c16-895a-8fe3af8f8108",
    "https://firebasestorage.googleapis.com/v0/b/shopping-app-38f32.appspot.com/o/images%2Fpicture3.jpeg?alt=media&token=a0d9dd2a-305c-4313-b3fe-aaea056e45b3",
    "https://firebasestorage.googleapis.com/v0/b/shopping-app-38f32.appspot.com/o/images%2Fpicture4.jpeg?alt=media&token=76e63042-e3d1-4144-ad5e-db885c8db686",
    "https://firebasestorage.googleapis.com/v0/b/shopping-app-38f32.appspot.com/o/images%2Fpicture5.jpeg?alt=media&token=93137037-3981-4117-9135-b0341f8e9e40",
    "https://firebasestorage.googleapis.com/v0/b/shopping-app-38f32.appspot.com/o/images%2Fpicture6.jpeg?alt=media&token=2af9fb7d-fa19-4c92-8ecc-e1e3dbf10b98",
    "https://firebasestorage.googleapis.com/v0/b/shopping-app-38f32.appspot.com/o/images%2Fpicture7.jpeg?alt=media&token=c2c8fd93-db9b-4a56-bb01-d334ce9e0e25",
    "https://firebasestorage.googleapis.com/v0/b/shopping-app-38f32.appspot.com/o/images%2Fpicture8.jpeg?alt=media&token=1382412f-50aa-4a11-ac93-06c211d56325",
    "https://firebasestorage.googleapis.com/v0/b/shopping-app-38f32.appspot.com/o/images%2Fpicture9.jpeg?alt=media&token=94442cd1-51ad-4f67-9237-9229d76c00f6",
  ];

  List<String> names = [
    "Liam Johnson",
    "Emma Williams",
    "Noah Brown",
    "Olivia Jones",
    "William Garcia",
    "Ava Miller",
    "James Davis",
    "Sophia Martinez",
    "Benjamin Rodriguez",
    "Isabella Hernandez",
    "Lucas Wilson",
    "Mia Anderson",
    "Mason Thomas",
    "Charlotte Taylor",
    "Ethan Moore",
    "Amelia Martin",
    "Alexander Jackson",
    "Harper Lee",
    "Michael White",
    "Evelyn Harris",
  ];

  List<String> reviews = [
    "Extremely comfortable and stylish!",
    "Great fit and very durable.",
    "Perfect for everyday wear.",
    "Lightweight and breathable, ideal for summer.",
    "The color is exactly as shown in the pictures.",
    "Excellent support for long walks.",
    "Very well made, worth every penny.",
    "Fit perfectly and look great with jeans.",
    "High quality material, very satisfied.",
    "Sleek design and very comfortable.",
    "Amazing shoes, exceeded my expectations.",
    "Love the cushioning, feels like walking on air.",
    "Perfect for running, great grip and support.",
    "Stylish and comfortable, get lots of compliments.",
    "The fit is just right, no need for breaking in.",
    "Excellent arch support, very comfortable.",
    "Great for casual wear and looks stylish.",
    "Very comfortable for all-day wear.",
    "Trendy and functional, highly recommend.",
    "These shoes are incredibly light and comfy.",
    "Supportive and stylish, perfect for work.",
    "Perfect balance of comfort and style.",
    "Well-cushioned and durable, great for jogging.",
    "Fantastic quality, fits true to size.",
    "Breathable material, keeps feet cool.",
    "Comfortable right out of the box.",
    "Sole provides excellent traction.",
    "Stylish design, matches with multiple outfits.",
    "Great value for the price.",
    "Perfect for long standing hours.",
    "These shoes have a premium feel.",
    "Ideal for outdoor activities, very sturdy.",
    "Fashionable and functional, love them!",
    "The insoles are super soft and comfy.",
    "Excellent for hiking, very supportive.",
    "Nice balance of firmness and flexibility.",
    "Perfect for both casual and formal occasions.",
    "High-quality stitching, very durable.",
    "Feels like a custom fit.",
    "Keeps feet warm and dry in cold weather.",
  ];

  List<DateTime> dateTimes = [
    DateTime(2024, 6, 8, 14, 37, 29),
    DateTime(2024, 6, 9, 9, 12, 45),
    DateTime(2024, 6, 10, 21, 3, 14),
    DateTime(2024, 6, 11, 7, 48, 52),
    DateTime(2024, 6, 12, 18, 26, 33),
    DateTime(2024, 6, 8, 23, 10, 5),
    DateTime(2024, 6, 9, 5, 15, 47),
    DateTime(2024, 6, 10, 12, 50, 21),
    DateTime(2024, 6, 11, 3, 33, 58),
    DateTime(2024, 6, 12, 14, 22, 11),
    DateTime(2024, 6, 8, 11, 55, 6),
    DateTime(2024, 6, 9, 16, 40, 19),
    DateTime(2024, 6, 10, 20, 25, 50),
    DateTime(2024, 6, 11, 6, 7, 31),
    DateTime(2024, 6, 12, 9, 53, 44),
    DateTime(2024, 6, 8, 19, 41, 2),
    DateTime(2024, 6, 9, 4, 29, 14),
    DateTime(2024, 6, 10, 13, 5, 37),
    DateTime(2024, 6, 11, 17, 48, 22),
    DateTime(2024, 6, 12, 8, 16, 9),
  ];

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchAndUpdateDocuments() async {
    final CollectionReference<Map<String, dynamic>> colorsCollection =
        FirebaseFirestore.instance.collection('products');
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await colorsCollection.get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> document
          in snapshot.docs) {
        Map<String, dynamic> data = document.data();
        // Replace the 'colors' list with a map
        Map<String, dynamic> colorsMap = {
          for (int i = 0; i < data['colors'].length; i++)
            'color$i': data['colors'][i],
        };
        // Update the document with the modified data
        await colorsCollection.doc(document.id).update({'colors': colorsMap});
      }
      print('Documents updated successfully');
    } catch (e) {
      print('Error fetching and updating documents: $e');
    }
  }

  getData() async {
    final data = await getIt<DiscoverApiService>().getFilteredProductList(
      FilterModel(
        brand: BrandsModel(name: 'Puma', logo: ''),
        gender: Gender.man,
        sortBy: SortByModel(sortBy: SortBy.highestReviews, descending: true),
        color: ColorModel(color: Colors.white, name: StringManager.white),
        priceRange: PriceRangeModel(minPrice: 250),
      ),
    );

    // for (int i = 0; i < 18; i++) {
    //   imageList.shuffle();
    //   names.shuffle();
    //   reviews.shuffle();
    //   dateTimes.shuffle();

    //   Map<String, dynamic> json = {
    //     "name": names[Random().nextInt(names.length)],
    //     "image": imageList[Random().nextInt(imageList.length)],
    //     "review": reviews[Random().nextInt(reviews.length)],
    //     "created_at":
    //         Timestamp.fromDate(dateTimes[Random().nextInt(dateTimes.length)]),
    //     "rating": Random().nextInt(4) + 2,
    //     "product_id": i + 1,
    //   };
    //   await getIt<DiscoverApiService>().createProduct(json);
    //   await Future.delayed(const Duration(seconds: 2));
    // }

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
    // try {
    //   final fd = await getIt<DiscoverApiService>().createProduct(json);
    //   // if (fd.isRight) {
    //   //   print(fd);
    //   //   List<BrandsModel> mdk = fd.right.docs.map((val) => val.data()).toList();
    //   // } else {
    //   //   print('errorr message is ${fd.left.message}');
    //   // }

    //   // return;
    //   // QuerySnapshot data = await getIt<FirebaseFirestore>()
    //   //     .collection('products')
    //   //     .where('brand', isEqualTo: 'Vans')
    //   //     // .orderBy('name')
    //   //     // .startAfter([''])
    //   //     // .limit(2)
    //   //     .get();
    print('length is ${data.docs.length}');
    for (DocumentSnapshot<ProductModel> item in data.docs) {
      print('name is this ${item.data()?.colors.first.toJson()}');
    }
    // } catch (e) {
    //   print(e);
    // }
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
