import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_idea_pool/blocs/auth/auth_bloc.dart';
import 'package:my_idea_pool/blocs/idea/idea_bloc.dart';
import 'package:my_idea_pool/models/app_idea.dart';
import 'package:my_idea_pool/models/idea_editor_actions.dart';
import 'package:my_idea_pool/models/models.dart';
import 'package:my_idea_pool/shared/common_utils.dart';

import 'idea_editor_page.dart';

class IdeaPoolMain extends StatefulWidget {
  IdeaPoolMain({Key key}) : super(key: key);

  @override
  _IdeaPoolMainState createState() => _IdeaPoolMainState();
}

class _IdeaPoolMainState extends State<IdeaPoolMain> {
  UserRepository _userRepository;
  //IdeaRepository _ideaRepository;
  IdeaEditorActions _ideaEditorActions;
  List<AppIdea> _ideas = List();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext buildContext) {
    if (_userRepository == null) {
      _userRepository = RepositoryProvider.of<UserRepository>(buildContext);
      //_ideaRepository = IdeaRepository(userRepository: _userRepository);
      _ideaEditorActions = IdeaEditorActions(context: buildContext);

      // force load on init
      BlocProvider.of<AuthBloc>(buildContext).add(RefreshTokenEvent());
      Future.delayed(Duration(seconds: 1));
      BlocProvider.of<IdeaBloc>(buildContext).add(LoadIdeasEvent());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'The Idea Pool',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: false,
        leading: Icon(
          Icons.lightbulb_outline,
          color: Colors.white,
        ),
        backgroundColor: Colors.green,
        actions: <Widget>[
          FlatButton.icon(
            // just for testing
            onPressed: () {
              //BlocProvider.of<AuthBloc>(buildContext).add(RefreshTokenEvent());
              //Future.delayed(Duration(seconds: 1));
              BlocProvider.of<IdeaBloc>(buildContext).add(LoadIdeasEvent());
            },
            icon: Icon(Icons.refresh),
            label: Text(""),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(right: 8.0),
            child: InkWell(
              child: Text(
                "Log out",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              onTap: () {
                BlocProvider.of<AuthBloc>(buildContext).add(LogoutEvent());
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          CommonUtils.logger.d('Button: add new idea');

          Navigator.push(
            buildContext,
            MaterialPageRoute<IdeaEditorPage>(
              builder: (_) => IdeaEditorPage(
                add: _ideaEditorActions.addIdea,
              ),
            ),
          );
        },
        child: Icon(
          Icons.add,
          size: 44,
        ),
        tooltip: 'Add new Idea',
      ),
      /*body: Container(
          child: Center(
        child: Text("TODO: Idea Pool main page"),
      )),*/
      body: BlocListener<IdeaBloc, IdeaState>(
        listenWhen: (prev, current) {
          return current is IdeasLoaded;
        },
        listener: (context, state) {
          if (state is IdeasLoaded) {
            setState(() {
              _ideas = state.ideas;

              CommonUtils.logger.d('ideas: $_ideas');
            });
          }
        },
        child: _ideas.isEmpty
            ? _emptyIdeasPage()
            : ListView.builder(
                itemCount: _ideas.length,
                physics: ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  final AppIdea idea = _ideas[index];
                  return _ideaCard(idea);
                },
              ),
      ),
    );
  }

  _ideaCard(AppIdea idea) {
    return Card(
      elevation: 2.0,
      child: ListTile(
        contentPadding: EdgeInsets.all(16.0),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(
              width: 300,
              child: Text(
                '${idea.content}',
                maxLines: 3,
                style: TextStyle(fontSize: 16),
              ),
            ),
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {
                CommonUtils.logger.d('more: $idea');

                final cupertinoAction = CupertinoActionSheet(
                  message: Text(
                    "Actions",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  actions: <Widget>[
                    CupertinoActionSheetAction(
                      child: Text("Edit"),
                      isDefaultAction: true,
                      onPressed: () {
                        print("EDIT clicked for ${idea.id}");
                      },
                    ),
                    CupertinoActionSheetAction(
                      child: Text("Delete"),
                      isDestructiveAction: true,
                      onPressed: () {
                        print("DELETE clicked for ${idea.id}");
                        _ideaEditorActions.deleteIdea(idea);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                  cancelButton: CupertinoActionSheetAction(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                );
                showCupertinoModalPopup(
                    context: context, builder: (context) => cupertinoAction);
              },
            )
          ],
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text('${idea.impact}'),
                    Text('Impact'),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text('${idea.ease}'),
                    Text('Ease'),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text('${idea.confidence}'),
                    Text('Confidence'),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text('${idea.average_score}'),
                Text('Avg.'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _emptyIdeasPage() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.lightbulb_outline, size: 99, color: Colors.blueGrey),
          Text(
            "Got Ideas?",
            style: TextStyle(fontSize: 33, color: Colors.blueGrey),
          )
        ],
      ),
    );
  }
}
