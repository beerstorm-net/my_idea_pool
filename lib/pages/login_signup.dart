import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  @override
  Widget build(BuildContext buildContext) {
    if (_userRepository == null) {
      _userRepository = RepositoryProvider.of<UserRepository>(buildContext);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'The Idea Pool',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        /*leading: MaterialButton(
          onPressed: () {},
          color: Colors.white,
          textColor: Colors.green,
          child: Icon(
            Icons.lightbulb_outline,
            size: 40,
          ),
          padding: EdgeInsets.all(16),
          shape: CircleBorder(),
        ),*/
        leading: Container(
          decoration: BoxDecoration(
            shape: BoxShape
                .circle, // You can use like this way or like the below line
            //borderRadius: new BorderRadius.circular(30.0),
            color: Colors.white,
          ),
          child: Icon(
            Icons.lightbulb_outline,
            color: Colors.green,
            size: 33,
          ),
        ),
        backgroundColor: Colors.green,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          // TODO: alert user on failure
        },
        buildWhen: (prev, current) {
          return current is SignupPageState || current is LoginPageState;
        },
        builder: (context, state) {
          return Container(
              alignment: Alignment.center,
              child: (state is SignupPageState) ? SignupPage() : LoginPage());
        },
      ),
    );
  }

  _signupPage() {}
}
