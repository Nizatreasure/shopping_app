import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';
import 'package:shopping_app/app/discover/data/data_sources/remote_data_sources.dart';
import 'package:shopping_app/app/discover/data/models/filter_model.dart';
import 'package:shopping_app/app/discover/data/models/product_review_model.dart';
import 'package:shopping_app/core/common/network/data_failure_model.dart';
import 'package:shopping_app/core/services/network_request_service.dart';

import '../models/brands_model.dart';
import '../models/product_model.dart';

part '../../domain/repositories/discover_repository.dart';

class DiscoverRepositoryImpl implements DiscoverRepository {
  final NetworkRequestService _networkRequestService;
  final DiscoverRemoteDataSource _discoverRemoteDataSource;
  DiscoverRepositoryImpl(
      this._discoverRemoteDataSource, this._networkRequestService);

  @override
  Future<Either<DataFailure, QuerySnapshot<BrandsModel>>> getAllBrands() {
    return _networkRequestService.makeRequest(request: () {
      return _discoverRemoteDataSource.getAllBrands();
    });
  }

  @override
  Future<Either<DataFailure, QuerySnapshot<ProductModel>>> getProductList(
      String name) {
    return _networkRequestService.makeRequest(request: () {
      return _discoverRemoteDataSource.getProductList(name);
    });
  }

  @override
  Future<Either<DataFailure, DocumentSnapshot<ProductModel>>> getProductDetails(
      String docID) {
    return _networkRequestService.makeRequest(request: () {
      return _discoverRemoteDataSource.getProductDetails(docID);
    });
  }

  @override
  Future<Either<DataFailure, QuerySnapshot<ProductModel>>>
      getFilteredProductList(FilterModel filter) {
    return _networkRequestService.makeRequest(request: () {
      return _discoverRemoteDataSource.getFilteredProductList(filter);
    });
  }

  @override
  Future<Either<DataFailure, QuerySnapshot<ProductReviewModel>>>
      getProductReviews(int productID, int? rating) {
    return _networkRequestService.makeRequest(request: () {
      return _discoverRemoteDataSource.getProductReviews(productID, rating);
    });
  }

  @override
  Future<Either<DataFailure, QuerySnapshot<ProductReviewModel>>>
      getTopThreeReviews(int productID) {
    return _networkRequestService.makeRequest(request: () {
      return _discoverRemoteDataSource.getTopThreeReviews(productID);
    });
  }
}
