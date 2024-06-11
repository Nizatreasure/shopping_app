part of 'product_review_bloc.dart';

@immutable
class ProductReviewState {
  final List<ProductReviewTabModel> reviews;
  final int tabIndex;
  final int productID;

  const ProductReviewState(
      {required this.reviews, this.tabIndex = 0, this.productID = 0});

  ProductReviewState copyWith(
      {List<ProductReviewTabModel>? reviews, int? tabIndex, int? productID}) {
    return ProductReviewState(
      reviews: reviews ?? this.reviews,
      tabIndex: tabIndex ?? this.tabIndex,
      productID: productID ?? this.productID,
    );
  }
}
