import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/blocs.dart';
import '../models/app_idea.dart';

class IdeaEditorActions {
  BuildContext _context;
  //UserRepository _userRepository;
  IdeaEditorActions({@required BuildContext context})
      : assert(context != null),
        _context = context;

  AppIdea _appIdeaFromInput(Map<String, dynamic> formInput) {
    AppIdea appIdea = AppIdea();
    appIdea.content = formInput.containsKey('content')
        ? formInput['content'] as String
        : null;
    appIdea.impact =
        formInput.containsKey('impact') ? formInput['impact'] as String : null;
    appIdea.ease =
        formInput.containsKey('ease') ? formInput['ease'] as String : null;
    appIdea.confidence = formInput.containsKey('confidence')
        ? formInput['confidence'] as String
        : null;
    appIdea.average_score = formInput.containsKey('average_score')
        ? formInput['average_score'] as double
        : null;
    return appIdea;
  }

  void addIdea(Map<String, dynamic> formInput) {
    AppIdea appIdea = _appIdeaFromInput(formInput);

    if (appIdea.content != null) {
      BlocProvider.of<IdeaBloc>(_context).add(AddIdeaEvent(appIdea));
    }
  }

  void updateIdea(Map<String, dynamic> formInput, {AppIdea appIdea}) {
    AppIdea appIdeaToUpdate = _appIdeaFromInput(formInput);

    if (appIdea != null && appIdea.id != null) {
      // edit existing idea
      appIdeaToUpdate.id = appIdea.id;
    }

    if (appIdeaToUpdate != null && appIdeaToUpdate.content != null) {
      BlocProvider.of<IdeaBloc>(_context).add(UpdateIdeaEvent(appIdeaToUpdate));
    }
  }

  void deleteIdea(AppIdea appIdea) {
    // FIXME: make use of only ID! we don't need the whole model
    if (appIdea.id != null) {
      BlocProvider.of<IdeaBloc>(_context).add(DeleteIdeaEvent(appIdea));
    }
  }
}
