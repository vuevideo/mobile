import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:bloc/bloc.dart';

import 'package:authentication_repository/authentication_repository.dart';

import 'package:mobile/app/app.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Bloc observer = const AppBlocObserver() as Bloc;

  await Hive.initFlutter();
  await Hive.openBox<dynamic>(AUTHENTICATION_HIVE_BOX);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final OfflineAuthentication offlineAuthentication = OfflineAuthentication();

  final AuthenticationRepository authenticationRepository =
      AuthenticationRepository(
    firebaseAuth: FirebaseAuth.instance,
    apiUrl: "http://10.0.2.2:3000",
    offlineAuthentication: offlineAuthentication,
  );

  await (await authenticationRepository.user.first);

  runApp(
    App(
      authenticationRepository: authenticationRepository,
    ),
  );
}
