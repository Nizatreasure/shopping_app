part of 'product_review_bloc.dart';

@immutable
abstract class ProductReviewEvent {
  const ProductReviewEvent();
}

class ProductReviewGetReviewEvent extends ProductReviewEvent {
  final int index;
  final int? productID;
  const ProductReviewGetReviewEvent(this.index, {this.productID});
}

class ProductReviewSetProductIdEvent extends ProductReviewEvent {
  final int productID;

  const ProductReviewSetProductIdEvent(this.productID);
}

class ProductReviewChangeTabIndexEvent extends ProductReviewEvent {
  final int index;
  const ProductReviewChangeTabIndexEvent(this.index);
}
