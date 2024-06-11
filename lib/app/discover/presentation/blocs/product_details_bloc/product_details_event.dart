part of 'product_details_bloc.dart';

@immutable
abstract class ProductDetailsEvent {
  const ProductDetailsEvent();
}

class ProductDetailsGetProductDetailsEvent extends ProductDetailsEvent {
  final String documentID;
  const ProductDetailsGetProductDetailsEvent(this.documentID);
}

class ProductDetailsSetColorChoiceEvent extends ProductDetailsEvent {
  final ColorModel color;
  const ProductDetailsSetColorChoiceEvent(this.color);
}

class ProductDetailsChangeImageIndexEvent extends ProductDetailsEvent {
  final int index;
  const ProductDetailsChangeImageIndexEvent(this.index);
}

class ProductDetailsSetSizeEvent extends ProductDetailsEvent {
  final num size;
  const ProductDetailsSetSizeEvent(this.size);
}

class ProductDetailsGetTopThreeReviewsEvent extends ProductDetailsEvent {
  final int productID;
  const ProductDetailsGetTopThreeReviewsEvent(this.productID);
}

class ProductDetailsChangeQuantityEvent extends ProductDetailsEvent {
  final int quantity;
  const ProductDetailsChangeQuantityEvent(this.quantity);
}
