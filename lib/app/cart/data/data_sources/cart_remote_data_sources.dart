import 'package:shopping_app/app/cart/data/data_sources/remote/cart_api_service.dart';
import 'package:shopping_app/app/cart/data/models/cart_model.dart';

abstract class CartRemoteDataSources {
  Future<void> addProductToCart(CartModel cartModel);
  Stream<List<CartModel>> getCartItems();
  Future<void> updateCartItemQuantity(
      {required CartModel cartModel, required String cartDocumentID});
  Future<void> deleteProductFromCart(String cartDocumentID);
}

class CartRemoteDataSourcesImpl implements CartRemoteDataSources {
  final CartApiService _cartApiService;
  const CartRemoteDataSourcesImpl(this._cartApiService);

  @override
  Future<void> addProductToCart(CartModel cartModel) async {
    await _cartApiService.addProductToCart(cartModel);
  }

  @override
  Stream<List<CartModel>> getCartItems() {
    return _cartApiService.getCartItems();
  }

  @override
  Future<void> updateCartItemQuantity(
      {required CartModel cartModel, required String cartDocumentID}) {
    return _cartApiService.updateCartItem(
        cartModel: cartModel, cartDocumentID: cartDocumentID);
  }

  @override
  Future<void> deleteProductFromCart(String cartDocumentID) {
    return _cartApiService.deleteProductFromCart(cartDocumentID);
  }
}
