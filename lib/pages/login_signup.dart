import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_idea_pool/widgets/common_dialogs.dart';

import '../blocs/auth/auth_bloc.dart';
import '../models/models.dart';
import 'login_page.dart';
import 'signup_page.dart';

class LoginSignup extends StatefulWidget {
  LoginSignup({Key key}) : super(key: key);

  @override
  _LoginSignupState createState() => _LoginSignupState();
}

class _LoginSignupState extends State<LoginSignup> {
  UserRepository _userRepository;
  bool isLoginPage = true;

  @override
  Widget build(BuildContext buildContext) {
    if (_userRepository == null) {
      _userRepository = RepositoryProvider.of<UserRepository>(buildContext);
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            appBarLeading(),
            Text(
              'The Idea Pool',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        centerTitle: false,
        backgroundColor: Colors.green,
        //leading: appBarLeading(),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        buildWhen: (prev, current) {
          return current is SignupPageState || current is LoginPageState;
        },
        builder: (context, state) {
          return Container(
              alignment: Alignment.center,
              height: 600,
              padding: EdgeInsets.only(top: 16.0, bottom: 16.0), //.all(8.0),
              child: (state is SignupPageState) ? SignupPage() : LoginPage());
        },
      ),
      /*body: BlocListener<AuthBloc, AuthState>(
        listenWhen: (prev, current) {
          return current is AuthState;
        },
        listener: (context, state) {
          if (state is LoginPageState) {
            setState(() {
              isLoginPage = true;
            });
          } else if (state is SignupPageState) {
            setState(() {
              isLoginPage = false;
            });
          }
        },
        child: isLoginPage ? LoginPage() : SignupPage(),
      ),*/
    );
  }
}
