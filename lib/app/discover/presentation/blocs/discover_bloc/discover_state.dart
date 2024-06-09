part of 'discover_bloc.dart';

@immutable
class DiscoverState {
  final List<BrandsModel>? brands;
  final List<ProductModel>? products;
  final DataStatus productStatus;
  final DataStatus brandStatus;

  const DiscoverState({
    this.brands,
    this.products,
    this.brandStatus = const DataStatus(data: null, state: DataState.initial),
    this.productStatus = const DataStatus(data: null, state: DataState.initial),
  });

  DiscoverState copyWith({
    List<BrandsModel>? brands,
    List<ProductModel>? products,
    DataStatus? productStatus,
    DataStatus? brandStatus,
  }) {
    return DiscoverState(
      brands: brands ?? this.brands,
      products: products ?? this.products,
      brandStatus: brandStatus ?? this.brandStatus,
      productStatus: productStatus ?? this.productStatus,
    );
  }
}
