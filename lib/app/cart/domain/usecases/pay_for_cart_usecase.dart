import 'package:either_dart/either.dart';
import 'package:shopping_app/app/cart/data/models/order_summary_model.dart';
import 'package:shopping_app/app/cart/data/repositories/cart_repository_impl.dart';
import 'package:shopping_app/core/common/network/data_failure_model.dart';
import 'package:shopping_app/core/common/usecase/base_usecase.dart';

class MakePaymentForCartUsecase extends BaseUseCase<OrderSummaryModel, void> {
  final CartRepository _cartRepository;
  MakePaymentForCartUsecase(this._cartRepository);

  @override
  Future<Either<DataFailure, void>> execute(
      {required OrderSummaryModel params}) {
    return _cartRepository.makePaymentForCart(params);
  }
}
