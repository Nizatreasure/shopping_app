import 'package:either_dart/either.dart';
import 'package:shopping_app/app/cart/data/models/cart_model.dart';
import 'package:shopping_app/app/cart/data/repositories/cart_repository_impl.dart';
import 'package:shopping_app/core/common/network/data_failure_model.dart';
import 'package:shopping_app/core/common/usecase/base_usecase.dart';

class GetCartItemsUsecase
    extends BaseUseCase<dynamic, Stream<List<CartDocumentChangedModel>>> {
  final CartRepository _cartRepository;
  GetCartItemsUsecase(this._cartRepository);

  @override
  Future<Either<DataFailure, Stream<List<CartDocumentChangedModel>>>> execute(
      {required params}) {
    return _cartRepository.getCartItems();
  }
}
