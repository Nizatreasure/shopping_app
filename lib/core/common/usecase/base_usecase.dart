import 'package:either_dart/either.dart';

import '../network/data_failure_model.dart';

//This class would be extended by every usecase
//througout the application
abstract class BaseUseCase<In, Out> {
  Future<Either<DataFailure, Out>> execute({required In params});
}
