import 'package:authentication_repository/authentication_repository.dart';
import 'package:hive/hive.dart';

class OfflineAuthentication {

  final Box<dynamic> _authenticationHiveBox = Hive.box(AUTHENTICATION_HIVE_BOX);

  void saveCredentialsToDevice(Credentials credentials) {
    log.i("Saving Credentials to Device");

    this._authenticationHiveBox.put(
          LOGGED_IN_USER,
          credentials,
        );

    log.i("Saved Credentials to Device");
  }

  Credentials fetchCredentialsFromDevice() {
    log.i("Fetching Credentials from Device");

    return this._authenticationHiveBox.get(
          LOGGED_IN_USER,
          defaultValue: const Credentials.empty(),
        );
  }

  void clearStorage() {
    log.i("Clearing Credentials from Device");

    this._authenticationHiveBox.clear();

    log.i("Cleared Credentials from Device");
  }
}
