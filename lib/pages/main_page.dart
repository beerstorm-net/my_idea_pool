import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../blocs/auth/auth_bloc.dart';
import '../models/models.dart';
import '../shared/common_utils.dart';
import '../widgets/common_dialogs.dart';
import 'idea_pool_main.dart';
import 'login_signup.dart';

class MainPage extends StatefulWidget {
  UserRepository userRepository;
  MainPage({Key key, UserRepository userRepository})
      : assert(userRepository != null),
        userRepository = userRepository,
        super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  ProgressDialog _progressDialog;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext buildContext) {
    if (_progressDialog == null) {
      _progressDialog = buildProgressDialog(
          buildContext, '...work in progress...',
          isDismissible: true, autoHide: Duration(seconds: 3));
    }

    return BlocConsumer<AuthBloc, AuthState>(listenWhen: (prev, current) {
      return current is WarnUserState;
    }, listener: (prev, current) {
      // progress dialog actions
      if (current is WarnUserState) {
        // progress dialog
        if (current.actions.contains("progress_start")) {
          _progressDialog.show();
        } else if (current.actions.contains("progress_stop")) {
          _progressDialog.hide();
        } else if (current.actions.contains("alert_message")) {
          // TODO: display alert dialog
          showAlertDialog(buildContext, current.message, type: "WARNING");
        }
      }
    }, buildWhen: (prev, current) {
      return (current is AuthState &&
          (current is Authenticated || current is Unauthenticated));
    }, builder: (context, state) {
      CommonUtils.logger.d("main.builder state: $state");

      BlocProvider.of<AuthBloc>(context).add(
          WarnUserEvent(List<String>()..add("progress_stop"), message: ""));
      if (state is Unauthenticated &&
              state.detail != null //&& state.origin == ORIGIN.LOGIN
          ) {
        BlocProvider.of<AuthBloc>(context).add(WarnUserEvent(
            List<String>()..add("alert_message"),
            message: state.detail['message']));
      }

      return Container(
        alignment: Alignment.center,
        child: RepositoryProvider(
          lazy: false,
          create: (buildContext) => widget.userRepository,
          child: (state is Authenticated) ? IdeaPoolMain() : LoginSignup(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _progressDialog?.hide();
    _progressDialog = null;

    super.dispose();
  }
}
