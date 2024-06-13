import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/app/discover/data/models/brands_model.dart';
import 'package:shopping_app/app/discover/data/models/filter_model.dart';
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
  final GetFilteredProductUsecase _getFilteredProductUsecase;

  final ScrollController _allProductsScrollController = ScrollController();
  ScrollController get allProductsScrollController =>
      _allProductsScrollController;

  DiscoverBloc(this._getBrandsUsecase, this._getProductListUsecase,
      this._getFilteredProductUsecase)
      : super(const DiscoverState()) {
    on<DiscoverGetBrandsEvent>(_getBrandsEventHandler);
    on<DiscoverGetProductListEvent>(_getProductListEventHandler);
    on<DiscoverTabIndexChangedEvent>(_tabIndexChangedEventHandler);
    on<DiscoverSetFilterEvent>(_setFilterEventHandler);
    on<DiscoverClearFilterEvent>(_clearFiltersEventHandler);
    on<DiscoverApplyFilterEvent>(_applyFiltersEventHandler);
  }

  _getBrandsEventHandler(
      DiscoverGetBrandsEvent event, Emitter<DiscoverState> emit) async {
    emit(state.copyWith(
        brandStatus: DataStatus.loading(),
        productTabs: List.from(state.productTabs)
          ..[0] = ProductTabModel(status: DataStatus.loading())));
    final dataSate = await _getBrandsUsecase.execute(params: null);

    if (dataSate.isRight) {
      emit(
        state.copyWith(
          brandStatus: DataStatus.success(),
          //add the new brands to the already existing tab (all tab)
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
      //emit the failed state
      emit(state.copyWith(
          brandStatus: DataStatus.failure(exception: dataSate.left),
          productTabs: List.from(state.productTabs)
            ..[0] = ProductTabModel(
                status: DataStatus.failure(exception: dataSate.left))));
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

    //if request was successful, update the state to reflect the new data
    if (dataSate.isRight) {
      emit(
        state.copyWith(
          productTabs: List.from(state.productTabs)
            ..[index] = state.productTabs[index].copyWith(
              product: dataSate.right.docs
                  .map((product) => product.data().copyWith(
                      //get the product brand details from the brand list before
                      //adding adding the brand and updating the state
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

  _setFilterEventHandler(
      DiscoverSetFilterEvent event, Emitter<DiscoverState> emit) {
    FilterModel filters = const FilterModel().copyWith(
      brand: event.filters.brand,
      setBrandToNull: event.filters.brand == null,
      color: event.filters.color,
      setColorToNull: event.filters.color == null,
      gender: event.filters.gender,
      setGenderToNull: event.filters.gender == null,
      priceRange: event.filters.priceRange,
      setPriceRangeToNull: event.filters.priceRange == null,
      sortBy: event.filters.sortBy,
      setSortByToNull: event.filters.sortBy == null,
    );
    emit(state.copyWith(filters: filters));
  }

  _clearFiltersEventHandler(
      DiscoverClearFilterEvent event, Emitter<DiscoverState> emit) {
    if (allProductsScrollController.hasClients) {
      allProductsScrollController.jumpTo(0);
    }
    emit(state.copyWith(
      filters: const FilterModel(),
      filteredProductsStatus: DataStatus.initial(),
      setFilteredProductsToNull: true,
      filterActive: false,
    ));
  }

  _applyFiltersEventHandler(
      DiscoverApplyFilterEvent event, Emitter<DiscoverState> emit) async {
    if (allProductsScrollController.hasClients) {
      allProductsScrollController.jumpTo(0);
    }
    //set active filter to true and reset the filtered products to null before,
    //making the request
    emit(
      state.copyWith(
          filteredProductsStatus: DataStatus.loading(),
          setFilteredProductsToNull: true,
          filterActive: true),
    );
    final dataSate =
        await _getFilteredProductUsecase.execute(params: state.filters);

    if (dataSate.isRight) {
      emit(
        state.copyWith(
            filteredProductsStatus: DataStatus.success(),
            filteredProducts: dataSate.right.docs
                .map((product) => product.data().copyWith(
                    brand: _getProductBrandFromBrandList(product.data().brand)))
                .toList()),
      );
    } else {
      emit(state.copyWith(
          filteredProductsStatus:
              DataStatus.failure(exception: dataSate.left)));
    }
  }

  // Get the brand data for product using the brand name
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
