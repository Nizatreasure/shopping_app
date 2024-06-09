import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';
import 'package:shopping_app/app/discover/data/models/product_model.dart';
import 'package:shopping_app/app/discover/data/repositories/discover_repository_impl.dart';
import 'package:shopping_app/core/common/network/data_failure_model.dart';
import 'package:shopping_app/core/common/usecase/base_usecase.dart';

class GetProductDetailUsecase
    extends BaseUseCase<String, DocumentSnapshot<ProductModel>> {
  final DiscoverRepository _discoverRepository;
  GetProductDetailUsecase(this._discoverRepository);

  @override
  Future<Either<DataFailure, DocumentSnapshot<ProductModel>>> execute(
      {required String params}) {
    return _discoverRepository.getProductDetails(params);
  }
}
