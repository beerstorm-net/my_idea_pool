import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:my_idea_pool/shared/common_utils.dart';

import '../../models/models.dart';
import '../../shared/app_defaults.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository _userRepository;

  AuthBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(UninitializedAuthState());

  @override
  AuthState get initialState => UninitializedAuthState();

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is AppStartedEvent) {
      yield* _mapAppStartedToState();
    } else if (event is LoginPageEvent) {
      yield LoginPageState();
    } else if (event is SignupPageEvent) {
      yield SignupPageState();
    } else if (event is SignupEvent) {
      yield* _mapSignupEventToState(event);
    } else if (event is LoginEvent) {
      yield* _mapLoginEventToState(event);
    } else if (event is LogoutEvent) {
      yield* _mapLogoutEventToState(event);
    } else if (event is RefreshTokenEvent) {
      yield* _mapRefreshTokenEventToState(event);
    } else if (event is CurrentUserEvent) {
      yield* _mapCurrentUserEventToState(event);
    }
  }

  Stream<AuthState> _mapSignupEventToState(SignupEvent event) async* {
    AppUser appUser = AppUser(
      email: event.formInput['email'] as String,
      password: event.formInput['password'] as String,
      name: event.formInput['name'] as String,
    );

    appUser = await _userRepository.signupUser(appUser: appUser);
    if (appUser.token != null) {
      _userRepository.sharedPrefUtils.prefsSaveUser(appUser);
      yield Authenticated(appUser, origin: ORIGIN.SIGNUP);
    } else {
      yield Unauthenticated(
          detail: Map()..putIfAbsent('message', () => 'API call failed'),
          origin: ORIGIN.SIGNUP);
    }
  }

  Stream<AuthState> _mapLoginEventToState(LoginEvent event) async* {
    AppUser appUser = AppUser(
      email: event.formInput['email'] as String,
      password: event.formInput['password'] as String,
    );

    appUser = await _userRepository.loginUser(appUser: appUser);
    if (appUser.token != null) {
      _userRepository.sharedPrefUtils.prefsSaveUser(appUser);
      yield Authenticated(appUser, origin: ORIGIN.LOGIN);
    } else {
      yield Unauthenticated(
          detail: Map()..putIfAbsent('message', () => 'API call failed'),
          origin: ORIGIN.LOGIN);
    }
  }

  Stream<AuthState> _mapLogoutEventToState(LogoutEvent event) async* {
    AppUser appUser = _userRepository.sharedPrefUtils.prefsGetUser();

    if (appUser != null) {
      appUser = await _userRepository.logoutUser(appUser: appUser);
      _userRepository.sharedPrefUtils.prefsSaveUser(null);
    }
    yield Unauthenticated(
        detail: Map()..putIfAbsent('message', () => 'Logout completed'),
        origin: ORIGIN.LOGOUT);
  }

  Stream<AuthState> _mapRefreshTokenEventToState(
      RefreshTokenEvent event) async* {
    AppUser appUser = _userRepository.sharedPrefUtils.prefsGetUser();
    if (appUser != null) {
      appUser = await _userRepository.refreshToken(appUser: appUser);
      if (appUser.token != null) {
        _userRepository.sharedPrefUtils.prefsSaveUser(appUser);
        // NB! no need to yield a state again
        //yield Authenticated(appUser, origin: ORIGIN.REFRESH_TOKEN);
      } else {
        yield Unauthenticated(
            detail: Map()
              ..putIfAbsent(
                  'message', () => 'API call failed while refreshToken'),
            origin: ORIGIN.REFRESH_TOKEN);
      }
    }
  }

  Stream<AuthState> _mapCurrentUserEventToState(CurrentUserEvent event) async* {
    AppUser appUser = _userRepository.sharedPrefUtils.prefsGetUser();
    if (appUser != null) {
      appUser = await _userRepository.currentUser(appUser: appUser);
      _userRepository.sharedPrefUtils.prefsSaveUser(appUser);
      yield Authenticated(appUser, origin: ORIGIN.CURRENT_USER);
    }
  }

  Stream<AuthState> _mapAppStartedToState() async* {
    try {
      AppUser appUser = _userRepository.sharedPrefUtils.prefsGetUser();
      CommonUtils.logger.d('current user: $appUser');
      if (appUser != null) {
        yield Authenticated(appUser);
      } else {
        yield Unauthenticated();
      }
    } catch (_) {
      yield Unauthenticated(); //(origin: ORIGIN.RELOAD);
    }
  }
}
