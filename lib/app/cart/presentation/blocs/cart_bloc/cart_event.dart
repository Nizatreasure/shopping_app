part of 'cart_bloc.dart';

abstract class CartEvent {
  const CartEvent();
}

class CartGetCartItemsEvent extends CartEvent {
  const CartGetCartItemsEvent();
}

class CartUpdateCartItemsEvent extends CartEvent {
  final CartDocumentChangedModel item;
  const CartUpdateCartItemsEvent(this.item);
}

class CartUpdateQuantityEvent extends CartEvent {
  final CartModel item;
  final bool increase;
  const CartUpdateQuantityEvent(this.item, {this.increase = true});
}

class CartDeleteProductEvent extends CartEvent {
  final CartModel item;
  final Completer<bool> completer;
  const CartDeleteProductEvent(this.item, this.completer);
}

class CartMakePaymentEvent extends CartEvent {
  const CartMakePaymentEvent();
}
