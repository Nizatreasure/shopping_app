import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/app/cart/data/models/cart_model.dart';
import 'package:shopping_app/app/cart/domain/usecases/usecases.dart';
import 'package:shopping_app/core/common/enums/enums.dart';
import 'package:shopping_app/core/common/network/data_status.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartItemsUsecase _getCartItemsUsecase;
  final UpdateCartItemUsecase _updateCartItemUsecase;
  StreamSubscription<List<CartModel>>? _cartItemSubscription;
  final DeleteProductFromCartUsecase _deleteProductFromCartUsecase;
  CartBloc(this._getCartItemsUsecase, this._updateCartItemUsecase,
      this._deleteProductFromCartUsecase)
      : super(const CartState()) {
    on<CartGetCartItemsEvent>(_getCartItemsEventHandler);
    on<CartUpdateQuantityEvent>(_updateQuantityEventHandler);
    on<CartUpdateCartItemsEvent>(_updateCartItemsEventHandler);
    on<CartDeleteProductEvent>(_deleteProductEventHandler);
  }

  _getCartItemsEventHandler(
      CartGetCartItemsEvent event, Emitter<CartState> emit) async {
    emit(state.copyWith(status: DataStatus.loading()));

    final dataState = await _getCartItemsUsecase.execute(params: null);
    if (dataState.isRight) {
      emit(state.copyWith(status: DataStatus.success()));
      _cartItemSubscription = dataState.right.listen((cartItems) {
        add(CartUpdateCartItemsEvent(cartItems));
      });
    } else {
      emit(state.copyWith(
          status: DataStatus.failure(exception: dataState.left)));
    }
  }

  _updateCartItemsEventHandler(
      CartUpdateCartItemsEvent event, Emitter<CartState> emit) {
    emit(state.copyWith(cartItems: event.items));
  }

  _updateQuantityEventHandler(
      CartUpdateQuantityEvent event, Emitter<CartState> emit) async {
    if (state.cartItems == null) return;
    List<CartModel> cartItems = List.from(state.cartItems!);
    int index = cartItems.indexWhere((element) => element.id == event.item.id);
    if (index < 0) return;
    CartModel item = cartItems[index];
    CartModel updatedItem = item.copyWith(loading: true);

    //emit the processing state
    emit(state.copyWith(cartItems: cartItems..[index] = updatedItem));

    final dataState = await _updateCartItemUsecase.execute(params: {
      'cart_model': updatedItem.copyWith(
          quantity: updatedItem.quantity + (event.increase ? 1 : -1)),
      'cart_document_id': state.cartItems![index].docID
    });

    updatedItem = updatedItem.copyWith(
      loading: false,
      quantity: dataState.isRight
          ? updatedItem.quantity + (event.increase ? 1 : -1)
          : null,
    );

    emit(state.copyWith(cartItems: cartItems..[index] = updatedItem));
  }

  _deleteProductEventHandler(
      CartDeleteProductEvent event, Emitter<CartState> emit) async {
    final dataState =
        await _deleteProductFromCartUsecase.execute(params: event.item.docID);
    event.completer.complete(dataState.isRight);
  }

  @override
  Future<void> close() {
    _cartItemSubscription?.cancel();
    return super.close();
  }
}
