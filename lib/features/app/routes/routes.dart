import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/features.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

FutureOr<String?> authenticationGuard(
    BuildContext context, GoRouterState state) {
  AppState appState = context.read<AppBloc>().state;

  if (appState.appStatus == AppStatus.Unauthenticated) {
    return LoginPage.routePath;
  } else {
    return null;
  }
}

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: HomePage.routePath,
      name: HomePage.routeName,
      builder: (BuildContext context, GoRouterState state) => const HomePage(),
      redirect: authenticationGuard,
    ),
    GoRoute(
      path: LoginPage.routePath,
      name: LoginPage.routeName,
      builder: (BuildContext context, GoRouterState state) => const LoginPage(),
    ),
    GoRoute(
      path: RegisterPage.routePath,
      name: RegisterPage.routeName,
      builder: (BuildContext context, GoRouterState state) =>
          const RegisterPage(),
    ),
  ],
);
