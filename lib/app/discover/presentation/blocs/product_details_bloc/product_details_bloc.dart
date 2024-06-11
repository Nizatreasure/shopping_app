import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/app/discover/data/models/product_model.dart';
import 'package:shopping_app/app/discover/data/models/product_review_model.dart';
import 'package:shopping_app/app/discover/domain/usecases/usecases.dart';
import 'package:shopping_app/core/common/enums/enums.dart';
import 'package:shopping_app/core/common/network/data_status.dart';
import 'package:shopping_app/core/constants/constants.dart';

part 'product_details_event.dart';
part 'product_details_state.dart';

class ProductDetailsBloc
    extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  final GetProductDetailUsecase _getProductDetailUsecase;
  final GetTopThreeReviewsUsecase _getTopThreeReviewsUsecase;
  final TextEditingController _quantityController = TextEditingController();
  TextEditingController get quantityController => _quantityController;

  ProductDetailsBloc(
      this._getProductDetailUsecase, this._getTopThreeReviewsUsecase)
      : super(const ProductDetailsState()) {
    _quantityController.text = state.quantity.toString();
    on<ProductDetailsGetProductDetailsEvent>(_getProductDetailsEventHandler);
    on<ProductDetailsSetColorChoiceEvent>(_setColorChoiceEventHandler);
    on<ProductDetailsChangeImageIndexEvent>(_changeImageIndexEventHandler);
    on<ProductDetailsSetSizeEvent>(_setSizeEventHandler);
    on<ProductDetailsGetTopThreeReviewsEvent>(_getTopThreeReviewsEventHandler);
    on<ProductDetailsChangeQuantityEvent>(_changeQuantityEventHandler);
  }

  _getProductDetailsEventHandler(ProductDetailsGetProductDetailsEvent event,
      Emitter<ProductDetailsState> emit) async {
    emit(state.copyWith(productStatus: DataStatus.loading()));
    final dataState =
        await _getProductDetailUsecase.execute(params: event.documentID);
    if (dataState.isRight) {
      emit(state.copyWith(
          productDetails: dataState.right.data(),
          productStatus: DataStatus.success()));
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
}
