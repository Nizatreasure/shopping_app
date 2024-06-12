import 'package:either_dart/either.dart';
import 'package:shopping_app/app/cart/data/data_sources/cart_remote_data_sources.dart';
import 'package:shopping_app/app/cart/data/models/cart_model.dart';
import 'package:shopping_app/app/cart/data/models/order_summary_model.dart';
import 'package:shopping_app/core/common/network/data_failure_model.dart';
import 'package:shopping_app/core/services/network_request_service.dart';

part '../../domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSources _cartRemoteDataSources;
  final NetworkRequestService _networkRequestService;
  const CartRepositoryImpl(
      this._cartRemoteDataSources, this._networkRequestService);

  @override
  Future<Either<DataFailure, void>> addProductToCart(CartModel cartModel) {
    return _networkRequestService.makeRequest(request: () {
      return _cartRemoteDataSources.addProductToCart(cartModel);
    });
  }

  @override
  Future<Either<DataFailure, Stream<List<CartDocumentChangedModel>>>>
      getCartItems() {
    return _networkRequestService.makeRequest(request: () {
      return _cartRemoteDataSources.getCartItems();
    });
  }

  @override
  Future<Either<DataFailure, void>> updateCartItemQuantity(
      {required CartModel cartModel, required String cartDocumentID}) {
    return _networkRequestService.makeRequest(request: () {
      return _cartRemoteDataSources.updateCartItemQuantity(
          cartModel: cartModel, cartDocumentID: cartDocumentID);
    });
  }

  @override
  Future<Either<DataFailure, void>> deleteProductFromCart(
      String cartDocumentID) {
    return _networkRequestService.makeRequest(request: () {
      return _cartRemoteDataSources.deleteProductFromCart(cartDocumentID);
    });
  }

  @override
  Future<Either<DataFailure, void>> makePaymentForCart(
      OrderSummaryModel order) {
    return _networkRequestService.makeRequest(request: () {
      return _cartRemoteDataSources.makePaymentForCart(order);
    });
  }
}
