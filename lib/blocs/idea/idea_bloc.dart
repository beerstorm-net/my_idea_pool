import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../models/app_idea.dart';
import '../../models/idea_repository.dart';

part 'idea_event.dart';
part 'idea_state.dart';

class IdeaBloc extends Bloc<IdeaEvent, IdeaState> {
  final IdeaRepository _ideaRepository;

  IdeaBloc({@required IdeaRepository ideaRepository})
      : assert(ideaRepository != null),
        _ideaRepository = ideaRepository,
        super(UninitializedIdeaState());

  @override
  IdeaState get initialState => UninitializedIdeaState();

  @override
  Stream<IdeaState> mapEventToState(IdeaEvent event) async* {
    if (event is LoadIdeasEvent) {
      yield* _mapLoadIdeasEventToState(event);
    } else if (event is AddIdeaEvent) {
      yield* _mapAddIdeaEventToState(event);
    } else if (event is UpdateIdeaEvent) {
      yield* _mapUpdateIdeaEventToState(event);
    } else if (event is DeleteIdeaEvent) {
      yield* _mapDeleteIdeaEventToState(event);
    }
  }

  Stream<IdeaState> _mapLoadIdeasEventToState(LoadIdeasEvent event) async* {
    List<AppIdea> appIdeas = await _ideaRepository.loadIdeas(page: event.page);
    yield IdeasLoaded(appIdeas);
  }

  Stream<IdeaState> _mapAddIdeaEventToState(AddIdeaEvent event) async* {
    AppIdea appIdea = await _ideaRepository.addIdea(appIdea: event.appIdea);
    yield IdeaAdded(appIdea);

    // force reload
    add(LoadIdeasEvent());
  }

  Stream<IdeaState> _mapUpdateIdeaEventToState(UpdateIdeaEvent event) async* {
    AppIdea appIdea = await _ideaRepository.updateIdea(appIdea: event.appIdea);
    yield IdeaUpdated(appIdea);

    // force reload
    add(LoadIdeasEvent());
  }

  Stream<IdeaState> _mapDeleteIdeaEventToState(DeleteIdeaEvent event) async* {
    AppIdea appIdea = await _ideaRepository.deleteIdea(appIdea: event.appIdea);
    yield IdeaDeleted(appIdea);

    // force reload
    add(LoadIdeasEvent());
  }
}
