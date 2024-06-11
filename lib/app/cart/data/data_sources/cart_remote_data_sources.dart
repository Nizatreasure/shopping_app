import 'package:shopping_app/app/cart/data/data_sources/remote/cart_api_service.dart';
import 'package:shopping_app/app/cart/data/models/cart_model.dart';

abstract class CartRemoteDataSources {
  Future<void> addProductToCart(CartModel cartModel);
}

class CartRemoteDataSourcesImpl implements CartRemoteDataSources {
  final CartApiService _cartApiService;
  const CartRemoteDataSourcesImpl(this._cartApiService);

  @override
  Future<void> addProductToCart(CartModel cartModel) async {
    await _cartApiService.addProductToCart(cartModel);
  }
}
