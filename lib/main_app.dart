import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_idea_pool/pages/main_page.dart';

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
      localizationsDelegates: [
        // Built-in localization of basic text for Material widgets
        GlobalMaterialLocalizations.delegate,
        // Built-in localization for text direction LTR/RTL
        GlobalWidgetsLocalizations.delegate,
        // Built-in localization of basic text for Cupertino widgets
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'),
      ],
      localeResolutionCallback:
          (Locale locale, Iterable<Locale> supportedLocales) {
        return locale;
      },
      title: 'My Idea Pool',
      home: MainPage(
        userRepository: widget.userRepository,
      ),
    );
  }
}
