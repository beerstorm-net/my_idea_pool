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
      child: SingleChildScrollView(
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
              height: 400,
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
                    BlocProvider.of<AuthBloc>(buildContext)
                        .add(LoginPageEvent());
                  },
                ),
              ],
            ),
          ],
        ),
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
                  FormBuilderValidators.min(8, errorText: 'min 8 chars long!'),
                  FormBuilderValidators.pattern(CommonUtils.passwordPattern(),
                      errorText: 'min 1 uppercase, 1 lowercase, and 1 number!'),
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
          color: Colors.green,
          child: Text(
            'SIGN UP',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            if (_signupFormKey.currentState.saveAndValidate()) {
              CommonUtils.logger.d(_signupFormKey.currentState.value);

              BlocProvider.of<AuthBloc>(context).add(WarnUserEvent(
                  List<String>()..add("progress_start"),
                  message: ""));

              BlocProvider.of<AuthBloc>(buildContext)
                  .add(SignupEvent(_signupFormKey.currentState.value));
            } else {
              CommonUtils.logger.d(_signupFormKey.currentState.value);
              CommonUtils.logger.d('validation failed');
            }
          },
        ),
      ],
    );
  }
}
