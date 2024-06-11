import 'package:either_dart/either.dart';
import 'package:shopping_app/app/cart/data/repositories/cart_repository_impl.dart';
import 'package:shopping_app/core/common/network/data_failure_model.dart';
import 'package:shopping_app/core/common/usecase/base_usecase.dart';

class DeleteProductFromCartUsecase extends BaseUseCase<String, void> {
  final CartRepository _cartRepository;
  DeleteProductFromCartUsecase(this._cartRepository);

  @override
  Future<Either<DataFailure, void>> execute({required String params}) {
    return _cartRepository.deleteProductFromCart(params);
  }
}
