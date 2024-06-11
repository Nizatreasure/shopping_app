part of '../../data/repositories/discover_repository_impl.dart';

abstract class DiscoverRepository {
  Future<Either<DataFailure, QuerySnapshot<BrandsModel>>> getAllBrands();

  Future<Either<DataFailure, QuerySnapshot<ProductModel>>> getProductList(
      String name);

  Future<Either<DataFailure, DocumentSnapshot<ProductModel>>> getProductDetails(
      String docID);

  Future<Either<DataFailure, QuerySnapshot<ProductModel>>>
      getFilteredProductList(FilterModel filter);

  Future<Either<DataFailure, QuerySnapshot<ProductReviewModel>>>
      getProductReviews(int productID, int? rating);

  Future<Either<DataFailure, QuerySnapshot<ProductReviewModel>>>
      getTopThreeReviews(int productID);
}
