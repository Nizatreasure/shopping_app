import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';
import 'package:shopping_app/app/discover/data/models/brands_model.dart';
import 'package:shopping_app/app/discover/data/repositories/discover_repository_impl.dart';
import 'package:shopping_app/core/common/network/data_failure_model.dart';
import 'package:shopping_app/core/common/usecase/base_usecase.dart';

class GetBrandsUsecase
    extends BaseUseCase<dynamic, QuerySnapshot<BrandsModel>> {
  final DiscoverRepository _discoverRepository;
  GetBrandsUsecase(this._discoverRepository);
  @override
  Future<Either<DataFailure, QuerySnapshot<BrandsModel>>> execute(
      {required params}) {
    return _discoverRepository.getAllBrands();
  }
}
