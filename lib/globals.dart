import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class Globals {
  static NumberFormat ratingFormat = NumberFormat('0.0');
  static NumberFormat currencyFormat =
      NumberFormat.simpleCurrency(name: 'USD', decimalDigits: 2);
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }
}
