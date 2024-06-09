import 'package:internet_connection_checker/internet_connection_checker.dart';

//This class is used to test the quality of the user's
//internet connection before making a request to firebase
//servers

abstract class ConnectionChecker {
  Future<bool> get isConnected;
}

class ConnectionCheckerImpl implements ConnectionChecker {
  final InternetConnectionChecker _internetConnection;
  ConnectionCheckerImpl(this._internetConnection);

  @override
  Future<bool> get isConnected => _internetConnection.hasConnection;
}
