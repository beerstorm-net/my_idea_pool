part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object> get props => [];
}

class AppStartedEvent extends AuthEvent {}

class SignupPageEvent extends AuthEvent {}

class LoginPageEvent extends AuthEvent {}

class SignupEvent extends AuthEvent {
  final Map<String, dynamic> formInput;
  const SignupEvent(this.formInput);

  @override
  List<Object> get props => [formInput];

  @override
  String toString() => 'SignupEvent {formInput: $formInput }';
}

class LoginEvent extends AuthEvent {
  final Map<String, dynamic> formInput;
  const LoginEvent(this.formInput);

  @override
  List<Object> get props => [formInput];

  @override
  String toString() => 'LoginEvent {formInput: $formInput }';
}

class LogoutEvent extends AuthEvent {}

class RefreshTokenEvent extends AuthEvent {}

class CurrentUserEvent extends AuthEvent {}

class WarnUserEvent extends AuthEvent {
  final List<String> actions;
  final String message;

  const WarnUserEvent(this.actions, {this.message});

  @override
  List<Object> get props => [actions, message];

  @override
  String toString() => 'WarnUserEvent { actions: $actions, message: $message }';
}
