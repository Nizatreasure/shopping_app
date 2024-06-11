import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';
import 'package:shopping_app/app/discover/data/models/product_review_model.dart';
import 'package:shopping_app/app/discover/data/repositories/discover_repository_impl.dart';
import 'package:shopping_app/core/common/network/data_failure_model.dart';
import 'package:shopping_app/core/common/usecase/base_usecase.dart';

class GetProductReviewsUsecase
    extends BaseUseCase<Map<String, int?>, QuerySnapshot<ProductReviewModel>> {
  final DiscoverRepository _discoverRepository;
  GetProductReviewsUsecase(this._discoverRepository);
  @override
  Future<Either<DataFailure, QuerySnapshot<ProductReviewModel>>> execute(
      {required Map<String, int?> params}) {
    return _discoverRepository.getProductReviews(
        params['product_id'] ?? 0, params['rating']);
  }
}
