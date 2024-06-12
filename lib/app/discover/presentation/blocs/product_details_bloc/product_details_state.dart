part of 'product_details_bloc.dart';

@immutable
class ProductDetailsState {
  final ProductModel? productDetails;
  final DataStatus productStatus;
  final num? selectedSize;
  final ColorModel? selectedColor;
  final int imageIndex;
  final List<ProductReviewModel>? productReviews;
  final DataStatus reviewStatus;
  final int quantity;
  final String? cartDocumentID;
  //tracks the action of adding a product to cart
  final DataStatus addToCartStatus;

  double get totalPrice => (productDetails?.price.amount ?? 0) * quantity;

  bool get loading =>
      productStatus.state == DataState.loading ||
      productStatus.state == DataState.initial ||
      reviewStatus.state == DataState.loading ||
      reviewStatus.state == DataState.initial;

  bool get loadingError =>
      productStatus.state == DataState.failure ||
      reviewStatus.state == DataState.failure;

  const ProductDetailsState({
    this.productDetails,
    this.productReviews,
    this.productStatus = const DataStatus(state: DataState.initial),
    this.reviewStatus = const DataStatus(state: DataState.initial),
    this.addToCartStatus = const DataStatus(state: DataState.initial),
    this.selectedColor,
    this.selectedSize,
    this.imageIndex = 0,
    this.quantity = 1,
    this.cartDocumentID,
  });

  ProductDetailsState copyWith({
    ProductModel? productDetails,
    DataStatus? productStatus,
    num? selectedSize,
    ColorModel? selectedColor,
    int? imageIndex,
    List<ProductReviewModel>? productReviews,
    DataStatus? reviewStatus,
    DataStatus? addToCartStatus,
    int? quantity,
    String? cartDocumentID,
  }) {
    return ProductDetailsState(
      productDetails: productDetails ?? this.productDetails,
      productStatus: productStatus ?? this.productStatus,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedColor: selectedColor ?? this.selectedColor,
      imageIndex: imageIndex ?? this.imageIndex,
      productReviews: productReviews ?? this.productReviews,
      reviewStatus: reviewStatus ?? this.reviewStatus,
      quantity: quantity ?? this.quantity,
      cartDocumentID: cartDocumentID ?? this.cartDocumentID,
      addToCartStatus: addToCartStatus ?? this.addToCartStatus,
    );
  }
}
