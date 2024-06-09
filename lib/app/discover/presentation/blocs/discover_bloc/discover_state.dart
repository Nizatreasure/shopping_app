part of 'discover_bloc.dart';

@immutable
class DiscoverState {
  final List<BrandsModel>? brands;
  final List<ProductModel>? products;
  final List<ProductTabModel> productTabs;
  final DataStatus productStatus;
  final DataStatus brandStatus;
  final int tabIndex;

  const DiscoverState({
    this.brands,
    this.products,
    this.tabIndex = 0,
    this.productTabs = const [],
    this.brandStatus = const DataStatus(state: DataState.initial),
    this.productStatus = const DataStatus(state: DataState.initial),
  });

  DiscoverState copyWith({
    List<BrandsModel>? brands,
    List<ProductModel>? products,
    DataStatus? productStatus,
    DataStatus? brandStatus,
    List<ProductTabModel>? productTabs,
    int? tabIndex,
  }) {
    return DiscoverState(
      brands: brands ?? this.brands,
      products: products ?? this.products,
      brandStatus: brandStatus ?? this.brandStatus,
      productStatus: productStatus ?? this.productStatus,
      productTabs: productTabs ?? this.productTabs,
      tabIndex: tabIndex ?? this.tabIndex,
    );
  }
}
