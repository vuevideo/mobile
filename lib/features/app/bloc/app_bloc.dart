import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:models/models.dart';

part 'app_event.dart';
part 'app_state.dart';

/// Bloc Implementation for App wide Authentication State.
class AppBloc extends Bloc<AppEvent, AppState> {

  // Authentication repository and Firebase user stream.
  final AuthenticationRepository _authenticationRepository;
  late final StreamSubscription<Future<Credentials>> _credentialsSubscription;

  // Bloc constructor
  AppBloc({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,

  // Initial state to use.
        super(
          authenticationRepository.currentUser.isEmpty()
              ? const AppState.unauthenticated()
              : AppState.authenticated(authenticationRepository.currentUser),
        ) {

    // Handling events and their corresponding state changes.
    on<AppAuthChanged>(_onUserChanged);
    on<AppLogoutRequested>(_onLogoutRequested);

    // Subscribing to the firebase user stream.
    _credentialsSubscription =
        _authenticationRepository.user.listen((credentials) async {
      add(AppAuthChanged(credentials: await credentials));
    });
  }

  /// Handle Authentication Changes Events.
  void _onUserChanged(AppAuthChanged event, Emitter<AppState> emit) {

    // Check if user is empty, if yes then emit authenticated state else
    // emit unauthenticated state.
    emit(
      event.credentials.isEmpty()
          ? const AppState.unauthenticated()
          : AppState.authenticated(event.credentials),
    );
  }

  /// Handle Authentication Login Events.
  void _onLogoutRequested(AppLogoutRequested event, Emitter<AppState> emit) {
    unawaited(_authenticationRepository.logOut());
  }

  @override
  Future<void> close() {
    _credentialsSubscription.cancel();
    return super.close();
  }
}
