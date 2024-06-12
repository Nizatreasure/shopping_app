import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/app/cart/data/models/cart_model.dart';
import 'package:shopping_app/app/cart/domain/usecases/usecases.dart';
import 'package:shopping_app/app/cart/presentation/blocs/cart_bloc/cart_bloc.dart';
import 'package:shopping_app/app/discover/data/models/product_model.dart';
import 'package:shopping_app/app/discover/data/models/product_review_model.dart';
import 'package:shopping_app/app/discover/domain/usecases/usecases.dart';
import 'package:shopping_app/core/common/enums/enums.dart';
import 'package:shopping_app/core/common/network/data_status.dart';
import 'package:shopping_app/core/common/widgets/app_loader_widget.dart';
import 'package:shopping_app/core/constants/constants.dart';
import 'package:shopping_app/core/values/string_manager.dart';
import 'package:shopping_app/main.dart';

part 'product_details_event.dart';
part 'product_details_state.dart';

class ProductDetailsBloc
    extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  final GetProductDetailUsecase _getProductDetailUsecase;
  final GetTopThreeReviewsUsecase _getTopThreeReviewsUsecase;
  final AddProductToCartUsecase _addProductToCartUsecase;
  final UpdateCartItemUsecase _updateCartItemUsecase;
  final TextEditingController _quantityController = TextEditingController();
  TextEditingController get quantityController => _quantityController;

  ProductDetailsBloc(
      this._getProductDetailUsecase,
      this._getTopThreeReviewsUsecase,
      this._addProductToCartUsecase,
      this._updateCartItemUsecase)
      : super(const ProductDetailsState()) {
    _quantityController.text = state.quantity.toString();
    on<ProductDetailsGetProductDetailsEvent>(_getProductDetailsEventHandler);
    on<ProductDetailsSetColorChoiceEvent>(_setColorChoiceEventHandler);
    on<ProductDetailsChangeImageIndexEvent>(_changeImageIndexEventHandler);
    on<ProductDetailsSetSizeEvent>(_setSizeEventHandler);
    on<ProductDetailsGetTopThreeReviewsEvent>(_getTopThreeReviewsEventHandler);
    on<ProductDetailsChangeQuantityEvent>(_changeQuantityEventHandler);
    on<ProductDetailsAddProductToCartEvent>(_addProductToCartEventHandler);
  }

  _getProductDetailsEventHandler(ProductDetailsGetProductDetailsEvent event,
      Emitter<ProductDetailsState> emit) async {
    emit(state.copyWith(productStatus: DataStatus.loading()));
    final dataState =
        await _getProductDetailUsecase.execute(params: event.documentID);
    if (dataState.isRight) {
      //check if product is in cart and update accordingly
      CartState cartState =
          MyApp.navigatorKey.currentContext!.read<CartBloc>().state;
      ProductModel? productModel = dataState.right.data();
      int index = cartState.cartItems?.indexWhere(
              (element) => element.productID == productModel?.id) ??
          -1;
      if (index >= 0) {
        CartModel cartModel = cartState.cartItems![index];
        quantityController.text = cartModel.quantity.toString();
        emit(state.copyWith(
          quantity: cartModel.quantity,
          selectedSize: cartModel.size,
          selectedColor: cartModel.color,
          cartDocumentID: cartModel.docID,
        ));
      }
      emit(state.copyWith(
          productDetails: productModel, productStatus: DataStatus.success()));
    } else {
      emit(state.copyWith(
          productStatus: DataStatus.failure(exception: dataState.left)));
    }
  }

  _setColorChoiceEventHandler(ProductDetailsSetColorChoiceEvent event,
      Emitter<ProductDetailsState> emit) {
    emit(state.copyWith(selectedColor: event.color));
  }

  _changeImageIndexEventHandler(ProductDetailsChangeImageIndexEvent event,
      Emitter<ProductDetailsState> emit) {
    emit(state.copyWith(imageIndex: event.index));
  }

  _setSizeEventHandler(
      ProductDetailsSetSizeEvent event, Emitter<ProductDetailsState> emit) {
    emit(state.copyWith(selectedSize: event.size));
  }

  _getTopThreeReviewsEventHandler(ProductDetailsGetTopThreeReviewsEvent event,
      Emitter<ProductDetailsState> emit) async {
    emit(state.copyWith(reviewStatus: DataStatus.loading()));
    final dataState =
        await _getTopThreeReviewsUsecase.execute(params: event.productID);

    if (dataState.isRight) {
      emit(state.copyWith(
          productReviews:
              dataState.right.docs.map((review) => review.data()).toList(),
          reviewStatus: DataStatus.success()));
    } else {
      emit(state.copyWith(
          reviewStatus: DataStatus.failure(exception: dataState.left)));
    }
  }

  _changeQuantityEventHandler(ProductDetailsChangeQuantityEvent event,
      Emitter<ProductDetailsState> emit) {
    //cannot add more than the specified quantity of product to cart
    int quantity = min(AppConstants.maxQuantityForProduct, event.quantity);
    //do not update the quantity text in the ui if the quantity is zero
    if (quantity != 0) {
      _quantityController.text = quantity.toString();
    }
    emit(state.copyWith(quantity: quantity));
  }

  _addProductToCartEventHandler(ProductDetailsAddProductToCartEvent event,
      Emitter<ProductDetailsState> emit) async {
    CartModel cartModel = CartModel.fromProduct(
      state.productDetails!,
      color: state.selectedColor!,
      quantity: state.quantity,
      size: state.selectedSize!,
    );
    AppLoaderWidget.showLoader(message: '${StringManager.addingToCart}...');
    emit(state.copyWith(addToCartStatus: DataStatus.loading()));
    final dataState = await (state.cartDocumentID != null
        ? _updateCartItemUsecase.execute(params: {
            'cart_model': cartModel,
            'cart_document_id': state.cartDocumentID
          })
        : _addProductToCartUsecase.execute(params: cartModel));
    AppLoaderWidget.dismissLoader();
    if (dataState.isRight) {
      emit(state.copyWith(addToCartStatus: DataStatus.success()));
    } else {
      emit(state.copyWith(
          addToCartStatus: DataStatus.failure(exception: dataState.left)));
    }
    emit(state.copyWith(addToCartStatus: DataStatus.initial()));
  }
}
