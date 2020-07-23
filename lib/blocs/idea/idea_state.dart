part of 'idea_bloc.dart';

abstract class IdeaState extends Equatable {
  const IdeaState();

  @override
  List<Object> get props => [];
}

class InitialIdeaState extends IdeaState {}

class UninitializedIdeaState extends IdeaState {}

class IdeaAction extends IdeaState {
  final String ideaAction;
  final AppIdea appIdea;

  const IdeaAction(this.ideaAction, this.appIdea);

  @override
  List<Object> get props => [ideaAction, appIdea];

  @override
  String toString() => '$ideaAction { appIdea: ${appIdea} }';
}

class IdeaAdded extends IdeaAction {
  IdeaAdded(AppIdea appIdea) : super("IdeaAdded", appIdea);
}

class IdeaUpdated extends IdeaAction {
  IdeaUpdated(AppIdea appIdea) : super("IdeaUpdated", appIdea);
}

class IdeaDeleted extends IdeaAction {
  IdeaDeleted(AppIdea appIdea) : super("IdeaDeleted", appIdea);
}

class IdeasLoaded extends IdeaState {
  final List<AppIdea> ideas;

  const IdeasLoaded([this.ideas = const []]);

  @override
  List<Object> get props => [ideas];

  @override
  String toString() => 'IdeasLoaded { ideas: $ideas }';
}
