import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../blocs/auth/auth_bloc.dart';
import '../shared/common_utils.dart';

class SignupPage extends StatefulWidget {
  SignupPage({Key key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  Map<String, String> _formInput = Map();

  @override
  void initState() {
    _formInput = Map();
    super.initState();
  }

  @override
  Widget build(BuildContext buildContext) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Sign Up',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: 20,
            height: 20,
          ),
          Container(
            height: 600,
            width: 300,
            child: _signupForm(buildContext),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Already have an account? "),
              InkWell(
                child: Text(
                  "Log in",
                  style: TextStyle(color: Colors.green, fontSize: 14),
                ),
                onTap: () {
                  BlocProvider.of<AuthBloc>(buildContext).add(LoginPageEvent());
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  final GlobalKey<FormBuilderState> _signupFormKey =
      GlobalKey<FormBuilderState>();
  _signupForm(BuildContext buildContext) {
    return ListView(
      children: <Widget>[
        FormBuilder(
          key: _signupFormKey,
          child: Column(
            children: <Widget>[
              FormBuilderTextField(
                attribute: "name",
                decoration: InputDecoration(labelText: "Name"),
                validators: [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.max(99),
                ],
              ),
              FormBuilderTextField(
                attribute: "email",
                decoration: InputDecoration(labelText: "Email"),
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
            'SIGN UP',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            if (_signupFormKey.currentState.saveAndValidate()) {
              CommonUtils.logger.d(_signupFormKey.currentState.value);

              BlocProvider.of<AuthBloc>(buildContext)
                  .add(SignupEvent(_signupFormKey.currentState.value));
            } else {
              CommonUtils.logger.d(_signupFormKey.currentState.value);
              CommonUtils.logger.d('validation failed');
            }
          },
        ),

        /*Row(
          children: <Widget>[
            Expanded(
              child: MaterialButton(
                color: Theme.of(context).accentColor,
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  if (_signupFormKey.currentState.saveAndValidate()) {
                    CommonUtils.logger.d(_signupFormKey.currentState.value);
                  } else {
                    CommonUtils.logger.d(_signupFormKey.currentState.value);
                    CommonUtils.logger.d('validation failed');
                  }
                },
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: MaterialButton(
                color: Theme.of(context).accentColor,
                child: Text(
                  'Reset',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  _signupFormKey.currentState.reset();
                },
              ),
            ),
          ],
        ), */
      ],
    );
  }
}
