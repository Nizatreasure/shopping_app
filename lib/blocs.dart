import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/app/cart/presentation/blocs/cart_bloc/cart_bloc.dart';
import 'package:shopping_app/app/discover/presentation/blocs/discover_bloc/discover_bloc.dart';

import 'di.dart';

class AppBlocs {
  static final _blocs = [
    BlocProvider<DiscoverBloc>(create: (_) => getIt()),
    BlocProvider<CartBloc>(create: (_) => getIt()),
  ];

  static get blocs => _blocs;
}
