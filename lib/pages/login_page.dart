import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../blocs/auth/auth_bloc.dart';
import '../shared/common_utils.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext buildContext) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Log In',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: 20,
            height: 20,
          ),
          Container(
            height: 600,
            width: 300,
            child: _loginForm(buildContext),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Don't have an account? "),
              InkWell(
                child: Text(
                  "Create an account",
                  style: TextStyle(color: Colors.green, fontSize: 14),
                ),
                onTap: () {
                  BlocProvider.of<AuthBloc>(buildContext)
                      .add(SignupPageEvent());
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  final GlobalKey<FormBuilderState> _loginFormKey =
      GlobalKey<FormBuilderState>();
  _loginForm(BuildContext buildContext) {
    return ListView(
      children: <Widget>[
        FormBuilder(
          key: _loginFormKey,
          child: Column(
            children: <Widget>[
              FormBuilderTextField(
                attribute: "email",
                decoration: InputDecoration(labelText: "Username"),
                validators: [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.email(),
                ],
              ),
              FormBuilderTextField(
                attribute: "password",
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true,
                maxLines: 1,
                validators: [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.min(8,
                      errorText: 'Password must be at least 8 chars long!'),
                  FormBuilderValidators.pattern(CommonUtils.passwordPattern(),
                      errorText:
                          'Password must contain at least 1 uppercase letter, 1 lowercase letter, and 1 number!'),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          width: 20,
          height: 20,
        ),
        MaterialButton(
          color: Theme.of(context).accentColor,
          child: Text(
            'LOG IN',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            if (_loginFormKey.currentState.saveAndValidate()) {
              CommonUtils.logger.d(_loginFormKey.currentState.value);

              BlocProvider.of<AuthBloc>(context).add(WarnUserEvent(
                  List<String>()..add("progress_start"),
                  message: ""));

              BlocProvider.of<AuthBloc>(buildContext)
                  .add(LoginEvent(_loginFormKey.currentState.value));
            } else {
              CommonUtils.logger.d(_loginFormKey.currentState.value);
              CommonUtils.logger.d('validation failed');
            }
          },
        ),
      ],
    );
  }
}
