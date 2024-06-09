import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'di.dart';
import 'firebase_options.dart';

class Globals {
  static NumberFormat ratingFormat = NumberFormat('0.0');
  static NumberFormat currencyFormat =
      NumberFormat.simpleCurrency(name: 'USD', decimalDigits: 2);
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    await initializeDependencies();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }
}
