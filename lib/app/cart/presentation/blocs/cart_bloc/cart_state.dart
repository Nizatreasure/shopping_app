part of 'cart_bloc.dart';

@immutable
class CartState {
  final List<CartModel>? cartItems;
  final DataStatus status;

  bool get loading =>
      status.state == DataState.initial || status.state == DataState.loading;

  bool get loadingError => status.state == DataState.failure;

  //add up the total prices of items in the cart to
  //get the grand total
  double get grandTotal =>
      cartItems?.fold(0, (total, item) => (total ?? 0) + item.totalPrice) ?? 0;

  //the number of items in the cart
  int get cartItemsCount => cartItems?.length ?? 0;

  //get the currency symbol if the cart is not empty
  String get currencySymbol =>
      (cartItems?.length ?? 0) >= 1 ? cartItems![0].price.symbol : '';

  const CartState(
      {this.cartItems,
      this.status = const DataStatus(state: DataState.initial)});

  CartState copyWith({List<CartModel>? cartItems, DataStatus? status}) {
    return CartState(
      cartItems: cartItems ?? this.cartItems,
      status: status ?? this.status,
    );
  }
}
