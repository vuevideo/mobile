import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final AuthenticationRepository _authenticationRepository;
  late final StreamSubscription<Future<Credentials>> _credentialsSubscription;

  AppBloc({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(
          authenticationRepository.currentUser.isEmpty()
              ? const AppState.unauthenticated()
              : AppState.authenticated(authenticationRepository.currentUser),
        ) {
    on<AppAuthChanged>(_onUserChanged);
    on<AppLogoutRequested>(_onLogoutRequested);

    _credentialsSubscription =
        _authenticationRepository.user.listen((credentials) async {
      add(AppAuthChanged(credentials: await credentials));
    });
  }

  void _onUserChanged(AppAuthChanged event, Emitter<AppState> emit) {
    emit(
      event.credentials.isEmpty()
          ? const AppState.unauthenticated()
          : AppState.authenticated(event.credentials),
    );
  }

  void _onLogoutRequested(AppLogoutRequested event, Emitter<AppState> emit) {
    unawaited(_authenticationRepository.logOut());
  }

  @override
  Future<void> close() {
    _credentialsSubscription.cancel();
    return super.close();
  }
}
