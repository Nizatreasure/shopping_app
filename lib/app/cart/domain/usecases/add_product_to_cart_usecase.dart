import 'package:either_dart/either.dart';
import 'package:shopping_app/app/cart/data/models/cart_model.dart';
import 'package:shopping_app/app/cart/data/repositories/cart_repository_impl.dart';
import 'package:shopping_app/core/common/network/data_failure_model.dart';
import 'package:shopping_app/core/common/usecase/base_usecase.dart';

class AddProductToCartUsecase extends BaseUseCase<CartModel, void> {
  final CartRepository _cartRepository;
  AddProductToCartUsecase(this._cartRepository);

  @override
  Future<Either<DataFailure, void>> execute({required CartModel params}) {
    return _cartRepository.addProductToCart(params);
  }
}
