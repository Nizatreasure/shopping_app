import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/app/cart/data/models/cart_model.dart';
import 'package:shopping_app/app/cart/data/models/order_summary_model.dart';
import 'package:shopping_app/app/cart/domain/usecases/usecases.dart';
import 'package:shopping_app/app/cart/presentation/pages/cart_page.dart';
import 'package:shopping_app/core/common/enums/enums.dart';
import 'package:shopping_app/core/common/network/data_status.dart';
import 'package:shopping_app/core/common/widgets/app_loader_widget.dart';
import 'package:shopping_app/core/constants/constants.dart';
import 'package:shopping_app/core/values/string_manager.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartItemsUsecase _getCartItemsUsecase;
  final UpdateCartItemUsecase _updateCartItemUsecase;
  StreamSubscription<List<CartDocumentChangedModel>>? _cartItemSubscription;
  final DeleteProductFromCartUsecase _deleteProductFromCartUsecase;
  final MakePaymentForCartUsecase _makePaymentForCartUsecase;

  final GlobalKey<AnimatedListState> _carListKey =
      GlobalKey<AnimatedListState>();
  GlobalKey<AnimatedListState> get carListKey => _carListKey;
  CartBloc(this._getCartItemsUsecase, this._updateCartItemUsecase,
      this._deleteProductFromCartUsecase, this._makePaymentForCartUsecase)
      : super(const CartState()) {
    on<CartGetCartItemsEvent>(_getCartItemsEventHandler);
    on<CartUpdateQuantityEvent>(_updateQuantityEventHandler);
    on<CartUpdateCartItemsEvent>(_updateCartItemsEventHandler);
    on<CartDeleteProductEvent>(_deleteProductEventHandler);
    on<CartMakePaymentEvent>(_makePaymetEventHandler);
  }

  _getCartItemsEventHandler(
      CartGetCartItemsEvent event, Emitter<CartState> emit) async {
    emit(state.copyWith(cartStatus: DataStatus.loading()));

    final dataState = await _getCartItemsUsecase.execute(params: null);
    if (dataState.isRight) {
      emit(state.copyWith(cartStatus: DataStatus.success()));
      _cartItemSubscription = dataState.right.listen((cartItems) {
        for (CartDocumentChangedModel item in cartItems) {
          add(CartUpdateCartItemsEvent(item));
        }
      });
    } else {
      emit(state.copyWith(
          cartStatus: DataStatus.failure(exception: dataState.left)));
    }
  }

  _updateCartItemsEventHandler(
      CartUpdateCartItemsEvent event, Emitter<CartState> emit) async {
    CartDocumentChangedModel item = event.item;
    List<CartModel> cartStateItems = List.from(state.cartItems ?? []);
    //insert the new item into the bloc state and update the UI
    if (item.type == DocumentChangeType.added) {
      emit(state.copyWith(
          cartItems: cartStateItems..insert(item.newIndex, item.cartModel)));
      _carListKey.currentState?.insertItem(item.newIndex);
      //insert item into the animated listview
    }

    //if document is modified only replace the item with the new update
    //I am maintaining the same key so that the animated list doesnt rebuild
    else if (item.type == DocumentChangeType.modified) {
      CartModel oldItem = cartStateItems[item.oldIndex];
      emit(state.copyWith(
          cartItems: cartStateItems
            ..[item.oldIndex] =
                item.cartModel.copyWith(itemKey: oldItem.itemKey)));
    }

    //document was deleted and should be removed from the UI
    else {
      _carListKey.currentState?.removeItem(
        item.oldIndex,
        (context, animation) => CartItemWidget(
          loading: false,
          animation: animation,
          cartModel: item.cartModel,
        ),
      );
      emit(state.copyWith(cartItems: cartStateItems..removeAt(item.oldIndex)));
    }
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

    await _updateCartItemUsecase.execute(params: {
      'cart_model': updatedItem.copyWith(
          quantity: updatedItem.quantity + (event.increase ? 1 : -1)),
      'cart_document_id': state.cartItems![index].docID
    });
  }

  _deleteProductEventHandler(
      CartDeleteProductEvent event, Emitter<CartState> emit) async {
    final dataState =
        await _deleteProductFromCartUsecase.execute(params: event.item.docID);
    event.completer.complete(dataState.isRight);
  }

  _makePaymetEventHandler(
      CartMakePaymentEvent event, Emitter<CartState> emit) async {
    AppLoaderWidget.showLoader();
    emit(state.copyWith(paymentStatus: DataStatus.loading()));
    final dataState = await _makePaymentForCartUsecase.execute(
      params: OrderSummaryModel(
        orderID:
            0, // not important, would be calculated before adding to the database
        subTotal: state.subTotal,
        shippingCost: state.shippingCost,
        location: state.location,
        paymentMethod: state.paymentMethod,
        orderDetails: state.cartItems!,
        createdAt: DateTime.now(),
        docID:
            'docID', //not important either. The value is not added to the database
      ),
    );
    AppLoaderWidget.dismissLoader();
    if (dataState.isRight) {
      emit(state.copyWith(paymentStatus: DataStatus.success()));
    } else {
      emit(state.copyWith(
          paymentStatus: DataStatus.failure(exception: dataState.left)));
    }

    //reset the payment status
    emit(state.copyWith(paymentStatus: DataStatus.initial()));
  }

  @override
  Future<void> close() {
    _cartItemSubscription?.cancel();
    return super.close();
  }
}
