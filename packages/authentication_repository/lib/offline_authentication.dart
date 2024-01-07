import 'package:authentication_repository/authentication_repository.dart';
import 'package:hive/hive.dart';

/// Repository for interacting with offline Hive database.
class OfflineAuthentication {

  // Hive Box for Authentication.
  final Box<Credentials> _authenticationHiveBox = Hive.box(AUTHENTICATION_HIVE_BOX);

  /// Store [Credentials] in offline Hive storage.
  void saveCredentialsToDevice(Credentials credentials) {
    log.i("Saving Credentials to Device");

    this._authenticationHiveBox.put(
          LOGGED_IN_USER,
          credentials,
        );

    log.i("Saved Credentials to Device");
  }

  /// Fetch [Credentials] from offline Hive storage.
  Credentials fetchCredentialsFromDevice() {
    log.i("Fetching Credentials from Device");

    return this._authenticationHiveBox.get(
          LOGGED_IN_USER,
          defaultValue: const Credentials.empty(),
        )!;
  }

  /// Clear offline Hive storage.
  void clearStorage() {
    log.i("Clearing Credentials from Device");

    this._authenticationHiveBox.clear();

    log.i("Cleared Credentials from Device");
  }
}
