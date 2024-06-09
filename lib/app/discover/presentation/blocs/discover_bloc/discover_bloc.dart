import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:shopping_app/app/discover/data/models/brands_model.dart';
import 'package:shopping_app/app/discover/data/models/product_model.dart';
import 'package:shopping_app/app/discover/data/models/product_tab_model.dart';
import 'package:shopping_app/app/discover/domain/usecases/usecases.dart';
import 'package:shopping_app/core/common/enums/enums.dart';
import 'package:shopping_app/core/common/network/data_status.dart';

part 'discover_event.dart';
part 'discover_state.dart';

class DiscoverBloc extends Bloc<DiscoverEvent, DiscoverState> {
  final GetBrandsUsecase _getBrandsUsecase;
  final GetProductListUsecase _getProductListUsecase;

  DiscoverBloc(this._getBrandsUsecase, this._getProductListUsecase)
      : super(const DiscoverState()) {
    on<DiscoverGetBrandsEvent>(_getBrandsEventHandler);
    on<DiscoverGetProductListEvent>(_getProductListEventHandler);
    on<DiscoverGetProductsByBrandEvent>(_getProductByBrandEventHandler);
    on<DiscoverTabIndexChangedEvent>(_tabIndexChangedEventHandler);
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
          //populate the tab data
          productTabs: List.generate(
              dataSate.right.docs.length, (index) => ProductTabModel()),
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

  _getProductByBrandEventHandler(DiscoverGetProductsByBrandEvent event,
      Emitter<DiscoverState> emit) async {
    int index = event.brandIndex;

    if (state.productTabs[index].status.state == DataState.success) {
      return;
    }
    emit(state.copyWith(
      productTabs: List.from(state.productTabs)
        ..[index] =
            state.productTabs[index].copyWith(status: DataStatus.loading()),
    ));
    final dataSate =
        await _getProductListUsecase.execute(params: state.brands![index].name);

    if (dataSate.isRight) {
      emit(
        state.copyWith(
          productTabs: List.from(state.productTabs)
            ..[index] = state.productTabs[index].copyWith(
              product:
                  dataSate.right.docs.map((product) => product.data()).toList(),
              status: DataStatus.success(),
            ),
        ),
      );
    } else {
      emit(state.copyWith(
        productTabs: List.from(state.productTabs)
          ..[index] = state.productTabs[index]
              .copyWith(status: DataStatus.failure(exception: dataSate.left)),
      ));
    }
    print('dddddddd ${state.productTabs[index].product?.length}');
    print('dddddddd ${state.productTabs[index].status.state}');
  }

  _tabIndexChangedEventHandler(
      DiscoverTabIndexChangedEvent event, Emitter<DiscoverState> emit) {
    emit(state.copyWith(tabIndex: event.index));
    if (event.index > 0) {
      add(DiscoverGetProductsByBrandEvent(event.index - 1));
    }
  }
}
