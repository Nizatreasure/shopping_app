import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shopping_app/app/cart/data/data_sources/cart_remote_data_sources.dart';
import 'package:shopping_app/app/cart/data/data_sources/remote/cart_api_service.dart';
import 'package:shopping_app/app/cart/data/repositories/cart_repository_impl.dart';
import 'package:shopping_app/app/cart/presentation/blocs/cart_bloc/cart_bloc.dart';
import 'package:shopping_app/app/discover/data/data_sources/remote_data_sources.dart';
import 'package:shopping_app/app/discover/data/models/product_review_model.dart';
import 'package:shopping_app/app/discover/presentation/blocs/discover_bloc/discover_bloc.dart';
import 'package:shopping_app/app/discover/presentation/blocs/product_details_bloc/product_details_bloc.dart';
import 'package:shopping_app/app/discover/presentation/blocs/product_review_bloc/product_review_bloc.dart';
import 'package:shopping_app/core/constants/constants.dart';
import 'package:shopping_app/core/values/string_manager.dart';

import 'app/cart/domain/usecases/usecases.dart';
import 'app/discover/data/data_sources/remote/api_service.dart';
import 'app/discover/data/repositories/discover_repository_impl.dart';
import 'app/discover/domain/usecases/usecases.dart';
import 'core/services/connection_checker.dart';
import 'core/services/network_request_service.dart';

final getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  //firestore
  getIt.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);

  //network
  getIt.registerSingleton<InternetConnectionChecker>(
      InternetConnectionChecker());
  getIt.registerSingleton<ConnectionChecker>(ConnectionCheckerImpl(getIt()));

  //services
  getIt
      .registerSingleton<NetworkRequestService>(NetworkRequestService(getIt()));
  getIt.registerSingleton<DiscoverApiService>(DiscoverApiService(getIt()));
  getIt.registerSingleton<CartApiService>(CartApiService(getIt()));

  //remote data sources
  getIt.registerSingleton<DiscoverRemoteDataSource>(
      DiscoverRemoteDataSourceImpl(getIt()));
  getIt.registerSingleton<CartRemoteDataSources>(
      CartRemoteDataSourcesImpl(getIt()));

  //repositories
  getIt.registerSingleton<DiscoverRepository>(
      DiscoverRepositoryImpl(getIt(), getIt()));
  getIt.registerSingleton<CartRepository>(CartRepositoryImpl(getIt(), getIt()));

  //usecases
  getIt.registerSingleton<GetBrandsUsecase>(GetBrandsUsecase(getIt()));
  getIt
      .registerSingleton<GetProductListUsecase>(GetProductListUsecase(getIt()));
  getIt.registerSingleton<GetProductDetailUsecase>(
      GetProductDetailUsecase(getIt()));
  getIt.registerSingleton<GetFilteredProductUsecase>(
      GetFilteredProductUsecase(getIt()));
  getIt.registerSingleton<GetProductReviewsUsecase>(
      GetProductReviewsUsecase(getIt()));
  getIt.registerSingleton<GetTopThreeReviewsUsecase>(
      GetTopThreeReviewsUsecase(getIt()));
  getIt.registerSingleton<AddProductToCartUsecase>(
      AddProductToCartUsecase(getIt()));
  getIt.registerSingleton<GetCartItemsUsecase>(GetCartItemsUsecase(getIt()));
  getIt
      .registerSingleton<UpdateCartItemUsecase>(UpdateCartItemUsecase(getIt()));
  getIt.registerSingleton<DeleteProductFromCartUsecase>(
      DeleteProductFromCartUsecase(getIt()));
  getIt.registerSingleton<MakePaymentForCartUsecase>(
      MakePaymentForCartUsecase(getIt()));

  //blocs
  getIt.registerFactory<DiscoverBloc>(
      () => DiscoverBloc(getIt(), getIt(), getIt()));
  getIt.registerFactory<ProductDetailsBloc>(
      () => ProductDetailsBloc(getIt(), getIt(), getIt(), getIt()));
  getIt.registerFactory<ProductReviewBloc>(
      () => ProductReviewBloc(_reviewTabs.reversed.toList(), getIt()));
  getIt.registerFactory<CartBloc>(
      () => CartBloc(getIt(), getIt(), getIt(), getIt()));
}

//
List<ProductReviewTabModel> get _reviewTabs =>
    List.generate(AppConstants.reviewTabLength, (index) {
      bool allTab = index == AppConstants.reviewTabLength - 1;
      return ProductReviewTabModel(
          tabTitle: allTab
              ? StringManager.all
              : '${index + 1} Star${index == 0 ? '' : 's'}',
          stars: allTab ? null : index + 1);
    });
