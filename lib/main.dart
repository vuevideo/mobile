import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:hive_flutter/hive_flutter.dart';

import 'package:authentication_repository/authentication_repository.dart';

import 'package:mobile/features/app/app.dart';
import 'firebase_options.dart';

/// Initialize all bits and pieces of Hive database.
Future<void> initializeHive() async {

  // Initialize Hive database.
  await Hive.initFlutter();

  // Register all model adapters for Hive.
  Hive.registerAdapter<Account>(AccountAdapter());
  Hive.registerAdapter<Credentials>(CredentialsAdapter());
  Hive.registerAdapter<ProfileImage>(ProfileImageAdapter());

  // Open all hive boxes for use.
  await Hive.openBox<Credentials>(AUTHENTICATION_HIVE_BOX);

}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeHive();

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
