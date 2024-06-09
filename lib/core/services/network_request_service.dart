import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';

import '../common/network/data_failure_model.dart';
import 'connection_checker.dart';

class NetworkRequestService {
  final ConnectionChecker _connectionChecker;
  NetworkRequestService(this._connectionChecker);

  Future<Either<DataFailure, Output>> makeRequest<Output>(
      {required Future<Output> Function() request}) async {
    if (await _connectionChecker.isConnected) {
      try {
        final response = await request();
        bool exists = true;
        if (response is DocumentSnapshot) {
          exists = response.exists;
        }

        if (exists) {
          return Right(response);
        } else {
          return Left(DataFailure());
        }
      } catch (e) {
        return Left(DataFailure());
      }
    } else {
      return Left(
          DataFailure(message: 'Please check your internet connection'));
    }
  }
}
