import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_idea_pool/widgets/common_dialogs.dart';

import '../blocs/auth/auth_bloc.dart';
import '../blocs/idea/idea_bloc.dart';
import '../models/app_idea.dart';
import '../models/idea_editor_actions.dart';
import '../models/models.dart';
import '../shared/common_utils.dart';
import 'idea_editor_page.dart';

class IdeaPoolMain extends StatefulWidget {
  IdeaPoolMain({Key key}) : super(key: key);

  @override
  _IdeaPoolMainState createState() => _IdeaPoolMainState();
}

class _IdeaPoolMainState extends State<IdeaPoolMain>
    with WidgetsBindingObserver {
  UserRepository _userRepository;
  //IdeaRepository _ideaRepository;
  IdeaEditorActions _ideaEditorActions;
  List<AppIdea> _ideas = List();
  @override
  void initState() {
    // if necessary, also listen to when first loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _forceReload();
    });

    // listen to appstates
    WidgetsBinding.instance.addObserver(this);

    super.initState();
  }

  _forceReload() {
    BlocProvider.of<AuthBloc>(context)
        .add(WarnUserEvent(List<String>()..add("progress_start"), message: ""));

    // force load on init
    BlocProvider.of<AuthBloc>(context).add(RefreshTokenEvent());
    Future.delayed(Duration(seconds: 1));
    BlocProvider.of<IdeaBloc>(context).add(LoadIdeasEvent());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _forceReload();
    } else {
      // NB! do smt if necessary when app is in the background
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  Widget build(BuildContext buildContext) {
    if (_userRepository == null) {
      _userRepository = RepositoryProvider.of<UserRepository>(buildContext);
      //_ideaRepository = IdeaRepository(userRepository: _userRepository);
      _ideaEditorActions = IdeaEditorActions(context: buildContext);
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
        //leading: appBarLeading(),
        backgroundColor: Colors.green,
        actions: <Widget>[
          FlatButton.icon(
            // just for testing
            onPressed: () {
              BlocProvider.of<AuthBloc>(context).add(WarnUserEvent(
                  List<String>()..add("progress_start"),
                  message: ""));
              BlocProvider.of<AuthBloc>(buildContext).add(RefreshTokenEvent());
              Future.delayed(Duration(seconds: 1));
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
      body: BlocListener<IdeaBloc, IdeaState>(
        listenWhen: (prev, current) {
          return current is IdeasLoaded;
        },
        listener: (context, state) {
          BlocProvider.of<AuthBloc>(context).add(
              WarnUserEvent(List<String>()..add("progress_stop"), message: ""));
          if (state is IdeasLoaded) {
            setState(() {
              _ideas = state.ideas;

              CommonUtils.logger.d('ideas: ${_ideas.length}');
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

                _showCupertinoAction(idea);
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
                Text('${idea.average_score.toStringAsFixed(1)}'),
                Text('Avg.'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _showCupertinoAction(AppIdea idea) {
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
            CommonUtils.logger.d("EDIT clicked for ${idea.id}");
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute<IdeaEditorPage>(
                builder: (_) => IdeaEditorPage(
                  update: _ideaEditorActions.updateIdea,
                  appIdea: idea,
                ),
              ),
            );
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Delete"),
          isDestructiveAction: true,
          onPressed: () {
            CommonUtils.logger.d("DELETE clicked for ${idea.id}");

            showCupertinoDialog(
                context: context,
                builder: (_) => CupertinoAlertDialog(
                      title: Text('Are you sure?'),
                      content: Text('This idea will be permanently deleted'),
                      actions: <Widget>[
                        CupertinoDialogAction(
                          child: Text('Cancel'),
                          isDefaultAction: true,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        CupertinoDialogAction(
                          child: Text('OK'),
                          isDestructiveAction: true,
                          onPressed: () {
                            Navigator.pop(context);

                            BlocProvider.of<AuthBloc>(context).add(
                                WarnUserEvent(
                                    List<String>()..add("progress_start"),
                                    message: ""));
                            _ideaEditorActions.deleteIdea(idea);

                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ));

            /*

            */
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
  }

  _emptyIdeasPage() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //Icon(Icons.lightbulb_outline, size: 99, color: Colors.blueGrey),
          appIconImage(color: Colors.black.withOpacity(0.88)),
          Text(
            "Got Ideas?",
            style: TextStyle(
                fontSize: 28, color: Colors.black87.withOpacity(0.66)),
          )
        ],
      ),
    );
  }
}
