import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_app/app/discover/data/data_sources/remote/api_service.dart';
import 'package:shopping_app/app/discover/data/models/filter_model.dart';
import 'package:shopping_app/app/discover/data/models/product_review_model.dart';

import '../models/brands_model.dart';
import '../models/product_model.dart';

abstract class DiscoverRemoteDataSource {
  Future<QuerySnapshot<BrandsModel>> getAllBrands();

  Future<QuerySnapshot<ProductModel>> getProductList(String name);

  Future<DocumentSnapshot<ProductModel>> getProductDetails(String docID);

  Future<QuerySnapshot<ProductModel>> getFilteredProductList(
      FilterModel filter);

  Future<QuerySnapshot<ProductReviewModel>> getProductReviews(
      int productID, int? rating);

  Future<QuerySnapshot<ProductReviewModel>> getTopThreeReviews(int productID);
}

class DiscoverRemoteDataSourceImpl implements DiscoverRemoteDataSource {
  final DiscoverApiService _discoverApiService;
  const DiscoverRemoteDataSourceImpl(this._discoverApiService);

  @override
  Future<QuerySnapshot<BrandsModel>> getAllBrands() async {
    return await _discoverApiService.getAllBrands();
  }

  @override
  Future<QuerySnapshot<ProductModel>> getProductList(String name) async {
    return await _discoverApiService.getProductList(name);
  }

  @override
  Future<DocumentSnapshot<ProductModel>> getProductDetails(String docID) async {
    return await _discoverApiService.getProductDetails(docID);
  }

  @override
  Future<QuerySnapshot<ProductModel>> getFilteredProductList(
      FilterModel filter) async {
    return await _discoverApiService.getFilteredProductList(filter);
  }

  @override
  Future<QuerySnapshot<ProductReviewModel>> getProductReviews(
      int productID, int? rating) async {
    return await _discoverApiService.getProductReviews(productID, rating);
  }

  @override
  Future<QuerySnapshot<ProductReviewModel>> getTopThreeReviews(
      int productID) async {
    return await _discoverApiService.getTopThreeReviews(productID);
  }
}
