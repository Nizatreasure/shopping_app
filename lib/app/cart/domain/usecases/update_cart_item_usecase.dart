import 'package:either_dart/either.dart';
import 'package:shopping_app/app/cart/data/repositories/cart_repository_impl.dart';
import 'package:shopping_app/core/common/network/data_failure_model.dart';
import 'package:shopping_app/core/common/usecase/base_usecase.dart';

class UpdateCartItemUsecase extends BaseUseCase<Map<String, dynamic>, void> {
  final CartRepository _cartRepository;
  UpdateCartItemUsecase(this._cartRepository);

  @override
  Future<Either<DataFailure, void>> execute(
      {required Map<String, dynamic> params}) {
    return _cartRepository.updateCartItemQuantity(
        cartModel: params['cart_model'],
        cartDocumentID: params['cart_document_id']);
  }
}
