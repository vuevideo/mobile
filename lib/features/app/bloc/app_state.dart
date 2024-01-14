part of 'app_bloc.dart';

enum AppStatus {
  Authenticated,
  Unauthenticated,
}

final class AppState extends Equatable {
  final AppStatus appStatus;
  final Credentials credentials;

  const AppState._({
    required this.appStatus,
    this.credentials = const Credentials.empty(),
  });

  const AppState.authenticated(Credentials credentials)
      : this._(
          appStatus: AppStatus.Authenticated,
          credentials: credentials,
        );

  const AppState.unauthenticated()
      : this._(
          appStatus: AppStatus.Unauthenticated,
        );

  @override
  List<Object?> get props => [
        appStatus,
        credentials,
      ];
}
