import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';

import '../common/network/data_failure_model.dart';
import 'connection_checker.dart';

class NetworkRequestService {
  final ConnectionChecker _connectionChecker;
  NetworkRequestService(this._connectionChecker);

  Future<Either<DataFailure, Output>> makeRequest<Output>(
      {required FutureOr<Output> Function() request}) async {
    //Checks for an internet connection before making the request
    if (await _connectionChecker.isConnected) {
      //adding a little delay because of the loader effect
      await Future.delayed(const Duration(milliseconds: 100));
      try {
        //make the request to the server
        final response = await request();
        bool exists = true;
        if (response is DocumentSnapshot) {
          exists = response.exists;
        }
        //Return Right if request was successful and left if it fails
        if (exists) {
          return Right(response);
        } else {
          return Left(DataFailure());
        }
      } catch (e) {
        return Left(DataFailure());
      }
    } else {
      // No stable connection
      await Future.delayed(const Duration(milliseconds: 400));
      return Left(
          DataFailure(message: 'Please check your internet connection'));
    }
  }
}
