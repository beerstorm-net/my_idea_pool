import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_idea_pool/blocs/auth/auth_bloc.dart';
import 'package:my_idea_pool/models/models.dart';

class IdeaPoolMain extends StatefulWidget {
  IdeaPoolMain({Key key}) : super(key: key);

  @override
  _IdeaPoolMainState createState() => _IdeaPoolMainState();
}

class _IdeaPoolMainState extends State<IdeaPoolMain> {
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
          style: TextStyle(color: Colors.white),
        ),
        leading: Icon(
          Icons.lightbulb_outline,
          color: Colors.white,
        ),
        backgroundColor: Colors.green,
        actions: <Widget>[
          InkWell(
            child: Text(
              "Log out",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            onTap: () {
              BlocProvider.of<AuthBloc>(buildContext).add(LogoutEvent());
            },
          ),
        ],
      ),
      body: Container(
          child: Center(
        child: Text("TODO: Idea Pool main page"),
      )),
    );
  }
}
