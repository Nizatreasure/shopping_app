part of '../../data/repositories/cart_repository_impl.dart';

abstract class CartRepository {
  Future<Either<DataFailure, void>> addProductToCart(CartModel cartModel);
}
