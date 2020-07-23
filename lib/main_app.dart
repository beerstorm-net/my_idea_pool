import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_idea_pool/pages/idea_pool_main.dart';
import 'package:my_idea_pool/pages/login_signup.dart';
import 'package:my_idea_pool/shared/common_utils.dart';

import 'blocs/auth/auth_bloc.dart';
import 'models/user_repository.dart';

class MainApp extends StatefulWidget {
  final UserRepository userRepository;
  MainApp({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        userRepository = userRepository,
        super(key: key);

  @override
  _MainAppState createState() => _MainAppState();
}

/// Navigator key to navigate without a BuildContext
final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext buildContext) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: _navigatorKey,
      title: 'My Idea Pool',
      home: BlocBuilder<AuthBloc, AuthState>(buildWhen: (prev, current) {
        return (current is AuthState &&
            (current is Authenticated || current is Unauthenticated));
      }, builder: (context, state) {
        CommonUtils.logger.d("main.builder state: $state");

        return Center(
          child: RepositoryProvider(
            lazy: false,
            create: (buildContext) => widget.userRepository,
            child: (state is Authenticated) ? IdeaPoolMain() : LoginSignup(),
          ),
        );
      }),
    );
  }
}
