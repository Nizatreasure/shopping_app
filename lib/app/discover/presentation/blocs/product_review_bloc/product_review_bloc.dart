import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/app/discover/data/models/product_review_model.dart';
import 'package:shopping_app/app/discover/domain/usecases/usecases.dart';
import 'package:shopping_app/core/common/enums/enums.dart';
import 'package:shopping_app/core/common/network/data_status.dart';

part 'product_review_event.dart';
part 'product_review_state.dart';

class ProductReviewBloc extends Bloc<ProductReviewEvent, ProductReviewState> {
  final List<ProductReviewTabModel> reviewTabs;
  final GetProductReviewsUsecase _getProductReviewsUsecase;

  ProductReviewBloc(this.reviewTabs, this._getProductReviewsUsecase)
      : super(ProductReviewState(reviews: reviewTabs)) {
    on<ProductReviewGetReviewEvent>(_getProductReviewsEventHandler);
    on<ProductReviewChangeTabIndexEvent>(_changeTabIndexEventHandler);
    on<ProductReviewSetProductIdEvent>(_setProductIdEventHandler);
  }

  _setProductIdEventHandler(
      ProductReviewSetProductIdEvent event, Emitter<ProductReviewState> emit) {
    emit(state.copyWith(productID: event.productID));
    add(ProductReviewGetReviewEvent(0, productID: event.productID));
  }

  _getProductReviewsEventHandler(ProductReviewGetReviewEvent event,
      Emitter<ProductReviewState> emit) async {
    int productID = event.productID ?? state.productID;

    if (productID == 0) return;

    int index = event.index;

    //Do not get data if the data has previously been fetched successfully
    if (state.reviews[index].status.state == DataState.success) {
      return;
    }

    //update the state to show that the reviews are loading
    emit(state.copyWith(
      reviews: List.from(state.reviews)
        ..[index] = state.reviews[index].copyWith(status: DataStatus.loading()),
    ));

    //get the reviews from firebase
    final dataSate = await _getProductReviewsUsecase.execute(
      params: {'product_id': productID, 'rating': state.reviews[index].stars},
    );

    //if request was successful, update the state to reflect the new data
    if (dataSate.isRight) {
      emit(
        state.copyWith(
          reviews: List.from(state.reviews)
            ..[index] = state.reviews[index].copyWith(
              reviews:
                  dataSate.right.docs.map((review) => review.data()).toList(),
              status: DataStatus.success(),
            ),
        ),
      );
    } else {
      emit(state.copyWith(
        reviews: List.from(state.reviews)
          ..[index] = state.reviews[index]
              .copyWith(status: DataStatus.failure(exception: dataSate.left)),
      ));
    }
  }

  _changeTabIndexEventHandler(ProductReviewChangeTabIndexEvent event,
      Emitter<ProductReviewState> emit) {
    emit(state.copyWith(tabIndex: event.index));
    add(ProductReviewGetReviewEvent(event.index));
  }

  // _getProductReviews(ProductReviewGetReviewEvent event , Emitter<ProductReviewState> emit) {}
}
