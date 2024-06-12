import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';

import '../common/network/data_failure_model.dart';
import 'connection_checker.dart';

class NetworkRequestService {
  final ConnectionChecker _connectionChecker;
  NetworkRequestService(this._connectionChecker);

  Future<void> dad() async {}

  Future<Either<DataFailure, Output>> makeRequest<Output>(
      {required FutureOr<Output> Function() request}) async {
    if (await _connectionChecker.isConnected) {
      print('internet is connected');
      await Future.delayed(const Duration(milliseconds: 100));
      print('internet is making request now');
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
        print('object $e');
        return Left(DataFailure());
      }
    } else {
      print('internet is not connected');
      await Future.delayed(const Duration(milliseconds: 400));
      return Left(
          DataFailure(message: 'Please check your internet connection'));
    }
  }
}
