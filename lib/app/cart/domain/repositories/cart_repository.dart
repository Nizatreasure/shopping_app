part of '../../data/repositories/cart_repository_impl.dart';

abstract class CartRepository {
  Future<Either<DataFailure, void>> addProductToCart(CartModel cartModel);
  Future<Either<DataFailure, Stream<List<CartModel>>>> getCartItems();
  Future<Either<DataFailure, void>> updateCartItemQuantity(
      {required CartModel cartModel, required String cartDocumentID});
  Future<Either<DataFailure, void>> deleteProductFromCart(
      String cartDocumentID);
}
