part of 'idea_bloc.dart';

abstract class IdeaEvent extends Equatable {
  const IdeaEvent();
  @override
  List<Object> get props => [];
}

class LoadIdeasEvent extends IdeaEvent {
  final int page;
  const LoadIdeasEvent({this.page = 1});

  @override
  List<Object> get props => [page];

  @override
  String toString() => 'LoadIdeasEvent { page: $page }';
}

class AddIdeaEvent extends IdeaEvent {
  final AppIdea appIdea;

  const AddIdeaEvent(this.appIdea);

  @override
  List<Object> get props => [appIdea];

  @override
  String toString() => 'AddIdeaEvent { appIdea: $appIdea }';
}

class UpdateIdeaEvent extends IdeaEvent {
  final AppIdea appIdea;

  const UpdateIdeaEvent(this.appIdea);

  @override
  List<Object> get props => [appIdea];

  @override
  String toString() => 'UpdateIdeaEvent { appIdea: $appIdea }';
}

class DeleteIdeaEvent extends IdeaEvent {
  final AppIdea appIdea;

  const DeleteIdeaEvent(this.appIdea);

  @override
  List<Object> get props => [appIdea];

  @override
  String toString() => 'DeleteIdeaEvent { appIdea: $appIdea }';
}
