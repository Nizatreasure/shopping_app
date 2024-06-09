import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:shopping_app/app/discover/data/models/brands_model.dart';
import 'package:shopping_app/app/discover/data/models/product_model.dart';
import 'package:shopping_app/app/discover/domain/usecases/usecases.dart';
import 'package:shopping_app/core/common/enums/enums.dart';
import 'package:shopping_app/core/common/network/data_status.dart';

part 'discover_event.dart';
part 'discover_state.dart';

class DiscoverBloc extends Bloc<DiscoverEvent, DiscoverState> {
  final GetBrandsUsecase _getBrandsUsecase;
  final GetProductListUsecase _getProductListUsecase;
  final GetProductDetailUsecase _getProductDetailUsecase;
  DiscoverBloc(this._getBrandsUsecase, this._getProductDetailUsecase,
      this._getProductListUsecase)
      : super(const DiscoverState()) {
    on<DiscoverGetBrandsEvent>(_getBrandsEventHandler);
    on<DiscoverGetProductListEvent>(_getProductListEventHandler);
    on<DiscoverGetProductDetailsEvent>(_getProductDetailsHandler);
  }

  _getBrandsEventHandler(
      DiscoverGetBrandsEvent event, Emitter<DiscoverState> emit) async {
    emit(state.copyWith(brandStatus: DataStatus.loading()));
    final dataSate = await _getBrandsUsecase.execute(params: null);

    if (dataSate.isRight) {
      emit(
        state.copyWith(
          brandStatus: DataStatus.success(),
          brands: dataSate.right.docs.map((brand) => brand.data()).toList(),
        ),
      );
    } else {
      emit(state.copyWith(
          brandStatus: DataStatus.failure(exception: dataSate.left)));
    }
  }

  _getProductListEventHandler(
      DiscoverGetProductListEvent event, Emitter<DiscoverState> emit) async {
    emit(state.copyWith(productStatus: DataStatus.loading()));
    final dataSate = await _getProductListUsecase.execute(params: '');

    if (dataSate.isRight) {
      emit(
        state.copyWith(
            productStatus: DataStatus.success(),
            products:
                dataSate.right.docs.map((product) => product.data()).toList()),
      );
    } else {
      emit(state.copyWith(
          productStatus: DataStatus.failure(exception: dataSate.left)));
    }
  }

  _getProductDetailsHandler(
      DiscoverGetProductDetailsEvent event, Emitter<DiscoverState> emit) {}
}
