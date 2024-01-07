part of 'app_bloc.dart';

sealed class AppEvent {
  const AppEvent();
}

final class AppLogoutRequested extends AppEvent {
  const AppLogoutRequested();
}

final class AppAuthChanged extends AppEvent {
  final Credentials credentials;

  const AppAuthChanged({
    required this.credentials,
  });
}
