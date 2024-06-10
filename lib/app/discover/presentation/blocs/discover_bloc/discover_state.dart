part of 'discover_bloc.dart';

@immutable
class DiscoverState {
  final List<BrandsModel> brands;
  final List<ProductModel>? filteredProducts;
  final List<ProductTabModel> productTabs;
  final DataStatus filteredProductsStatus;
  final DataStatus brandStatus;
  final int tabIndex;

  //initialize the state with the default values
  //including the values ‘all‘ product tab
  const DiscoverState({
    this.brands = const [BrandsModel(name: StringManager.all, logo: '')],
    this.filteredProducts,
    this.tabIndex = 0,
    this.productTabs = const [
      ProductTabModel(status: DataStatus(state: DataState.initial))
    ],
    this.brandStatus = const DataStatus(state: DataState.initial),
    this.filteredProductsStatus = const DataStatus(state: DataState.initial),
  });

  DiscoverState copyWith({
    List<BrandsModel>? brands,
    List<ProductModel>? filteredProducts,
    DataStatus? filteredProductsStatus,
    DataStatus? brandStatus,
    List<ProductTabModel>? productTabs,
    int? tabIndex,
  }) {
    return DiscoverState(
      brands: brands ?? this.brands,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      brandStatus: brandStatus ?? this.brandStatus,
      filteredProductsStatus:
          filteredProductsStatus ?? this.filteredProductsStatus,
      productTabs: productTabs ?? this.productTabs,
      tabIndex: tabIndex ?? this.tabIndex,
    );
  }
}
