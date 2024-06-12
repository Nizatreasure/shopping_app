part of 'cart_bloc.dart';

@immutable
class CartState {
  final List<CartModel>? cartItems;
  final DataStatus cartStatus;
  final DataStatus paymentStatus;

  bool get loading =>
      cartStatus.state == DataState.initial ||
      cartStatus.state == DataState.loading;

  bool get loadingError => cartStatus.state == DataState.failure;

  //sub total is the sum of all the prices of products in the cart
  double get subTotal =>
      cartItems?.fold(0, (total, item) => (total ?? 0) + item.totalPrice) ?? 0;

  //the number of items in the cart
  int get cartItemsCount => cartItems?.length ?? 0;

  //get the currency symbol if the cart is not empty
  String get currencySymbol =>
      (cartItems?.length ?? 0) >= 1 ? cartItems![0].price.symbol : '';

  //shipping cost. on a real project, this cost should be gotten from
  //an api but for testing purpose, it is fixed
  double get shippingCost => 35;

  //grand total is the sub total plus the shipping cost
  double get grandTotal => shippingCost + subTotal;

  //location
  String get location => AppConstants.defaultLocation;

  //payment method
  String get paymentMethod => StringManager.creditCard;

  const CartState(
      {this.cartItems,
      this.cartStatus = const DataStatus(state: DataState.initial),
      this.paymentStatus = const DataStatus(state: DataState.initial)});

  CartState copyWith({
    List<CartModel>? cartItems,
    DataStatus? cartStatus,
    DataStatus? paymentStatus,
  }) {
    return CartState(
      cartItems: cartItems ?? this.cartItems,
      cartStatus: cartStatus ?? this.cartStatus,
      paymentStatus: paymentStatus ?? this.paymentStatus,
    );
  }
}
