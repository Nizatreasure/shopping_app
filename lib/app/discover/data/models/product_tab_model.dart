import 'package:shopping_app/app/discover/data/models/product_model.dart';
import 'package:shopping_app/core/common/enums/enums.dart';
import 'package:shopping_app/core/common/network/data_status.dart';

class ProductTabModel {
  final List<ProductModel>? product;
  final DataStatus status;

  ProductTabModel({
    this.product,
    this.status = const DataStatus(state: DataState.initial),
  });

  ProductTabModel copyWith({List<ProductModel>? product, DataStatus? status}) {
    return ProductTabModel(
        product: product ?? this.product, status: status ?? this.status);
  }
}
