import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:shopping_app/app/discover/data/models/brands_model.dart';
import 'package:shopping_app/app/discover/data/models/product_model.dart';
import 'package:shopping_app/app/discover/data/models/product_tab_model.dart';
import 'package:shopping_app/app/discover/domain/usecases/usecases.dart';
import 'package:shopping_app/core/common/enums/enums.dart';
import 'package:shopping_app/core/common/network/data_status.dart';
import 'package:shopping_app/core/values/string_manager.dart';

part 'discover_event.dart';
part 'discover_state.dart';

class DiscoverBloc extends Bloc<DiscoverEvent, DiscoverState> {
  final GetBrandsUsecase _getBrandsUsecase;
  final GetProductListUsecase _getProductListUsecase;

  DiscoverBloc(this._getBrandsUsecase, this._getProductListUsecase)
      : super(const DiscoverState()) {
    on<DiscoverGetBrandsEvent>(_getBrandsEventHandler);
    on<DiscoverGetProductListEvent>(_getProductListEventHandler);
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
          brands: List.from(state.brands)
            ..addAll(dataSate.right.docs.map((brand) => brand.data()).toList()),
          //populate the tab data
          productTabs: List.from(state.productTabs)
            ..addAll(
              dataSate.right.docs
                  .map((brand) => const ProductTabModel())
                  .toList(),
            ),
        ),
      );
      add(const DiscoverGetProductListEvent(0));
    } else {
      emit(state.copyWith(
          brandStatus: DataStatus.failure(exception: dataSate.left)));
    }
  }

  _getProductListEventHandler(
      DiscoverGetProductListEvent event, Emitter<DiscoverState> emit) async {
    int index = event.index;

    //Do not get data if the data has previously been fetched successfully
    if (state.productTabs[index].status.state == DataState.success) {
      return;
    }

    //update the state to show that the products are loading
    emit(state.copyWith(
      productTabs: List.from(state.productTabs)
        ..[index] =
            state.productTabs[index].copyWith(status: DataStatus.loading()),
    ));

    //get the products from firebase
    //pass an empty string to fetch all products
    final dataSate = await _getProductListUsecase.execute(
        params: index == 0 ? '' : state.brands[index].name);

    if (dataSate.isRight) {
      //  List<ProductModel> = ;
      //get the brand information for the product

      //if request was successful, update the state to reflect the new data
      emit(
        state.copyWith(
          productTabs: List.from(state.productTabs)
            ..[index] = state.productTabs[index].copyWith(
              product: dataSate.right.docs
                  .map((product) => product.data().copyWith(
                      brand:
                          _getProductBrandFromBrandList(product.data().brand)))
                  .toList(),
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
  }

  _tabIndexChangedEventHandler(
      DiscoverTabIndexChangedEvent event, Emitter<DiscoverState> emit) {
    emit(state.copyWith(tabIndex: event.index));
    add(DiscoverGetProductListEvent(event.index));
  }

  BrandsModel _getProductBrandFromBrandList(BrandsModel brand) {
    String name = brand.name;
    List<BrandsModel> brands =
        state.brands.where((brand) => brand.name == name).toList();
    if (brands.isEmpty) {
      return brand; //return the same brand if there is no match
    }
    return brands.first;
  }
}
