import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/blocs.dart';
import 'blocs/simple_bloc_observer.dart';
import 'main_app.dart';
import 'models/user_repository.dart';
import 'shared/shared_preferences.dart';

final GlobalKey<ScaffoldState> _globalKeyMain =
    GlobalKey<ScaffoldState>(debugLabel: '_keyAppMain');
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();

  final SharedPref _sharedPref = new SharedPref();
  await _sharedPref.initSharedPreferences();
  final UserRepository _userRepository =
      UserRepository(sharedPref: _sharedPref);

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<AuthBloc>(
        lazy: false,
        create: (context) => AuthBloc(
          userRepository: _userRepository,
        )..add(AppStartedEvent()),
      )
    ],
    child: MainApp(
      key: _globalKeyMain,
      userRepository: _userRepository,
    ),
  ));
}
