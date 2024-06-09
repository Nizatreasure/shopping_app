import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';
import 'package:shopping_app/app/discover/data/data_sources/remote_data_sources.dart';
import 'package:shopping_app/core/common/network/data_failure.dart';
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
}
