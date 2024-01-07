import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:authentication_repository/authentication_repository.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// Repository Implementation for User Registration, Login and Logout.
class AuthenticationRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final String _apiUrl;
  final OfflineAuthentication _offlineAuthentication;

  AuthenticationRepository({
    required firebase_auth.FirebaseAuth firebaseAuth,
    required String apiUrl,
    required OfflineAuthentication offlineAuthentication,
  })  : _firebaseAuth = firebaseAuth,
        _apiUrl = apiUrl,
        _offlineAuthentication = offlineAuthentication;

  /// Validate HTTP requests and check for errors.
  /// If errors exist, throw the appropriate error.
  void _validateRequestAndThrowError({
    required http.Response response,
    required String errorLogName,
  }) {
    // Check for 4XX errors and throw errors accordingly
    if (response.statusCode >= 400 && response.statusCode < 500) {
      Map<String, dynamic> body = json.decode(response.body);
      throw ServerException(message: body['message']);
    }

    // Check for internal server error, log it and throw a server exception.
    else if (response.statusCode >= 500) {
      Map<String, dynamic> body = json.decode(response.body);
      log.e("$errorLogName Error", error: body['message']);
      throw ServerException(
        message: 'Something went wrong, please try again later.',
      );
    }
  }

  /// Stream of [Credentials] which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits [Credentials.empty] if the user is not authenticated.
  Stream<Future<Credentials>> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) async {
      Credentials credentials = await fetchLoggedInUser();

      this._offlineAuthentication.saveCredentialsToDevice(credentials);

      return credentials;
    });
  }

  /// Get current user regardless of authentication status.
  Credentials get currentUser {
    return this._offlineAuthentication.fetchCredentialsFromDevice();
  }

  /// Fetch credentials from server using Firebase Authentication
  ///
  /// Throws [ServerException] if any errors according to the server.
  Future<Credentials> fetchLoggedInUser() async {
    // If no user is logged in, return empty credentials.
    if (this._firebaseAuth.currentUser == null) {
      return Credentials.empty();
    }

    // Prepare URI for the request.
    Uri uri = Uri.parse("$_apiUrl/api/v1/user");

    // Fetch the ID token for the user.
    String? firebaseAuthToken =
        await this._firebaseAuth.currentUser!.getIdToken();

    // Prepare authorization headers.
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $firebaseAuthToken',
    };

    // Send the get request to the server.
    http.Response response = await http.get(
      uri,
      headers: headers,
    );

    // Check for any errors.
    _validateRequestAndThrowError(
      response: response,
      errorLogName: "AuthenticationRepository:fetchLoggedInUser",
    );

    // Decode JSON and create object based on it.
    dynamic jsonResponse = json.decode(response.body);
    Credentials credentials = Credentials.fromJson(jsonResponse);

    // Return credentials.
    return credentials;
  }

  /// Register a new account using [createAccountDto].
  ///
  /// Throws [ServerException] if any errors according to the server.
  Future<Credentials> registerWithEmailAndPassword({
    required CreateAccountDto createAccountDto,
  }) async {
    // Prepare URI for the request.
    Uri uri = Uri.parse("$_apiUrl/api/v1/auth");

    // Prepare authorization headers.
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    // Send the post request to the server.
    http.Response response = await http.post(
      uri,
      headers: headers,
      body: createAccountDto.toJson(),
    );

    // Check for any errors.
    _validateRequestAndThrowError(
      response: response,
      errorLogName: "AuthenticationRepository:registerWithEmailAndPassword",
    );

    // Decode JSON and create object based on it.
    dynamic jsonResponse = json.decode(response.body);
    Credentials credentials = Credentials.fromJson(jsonResponse);

    // Return credentials.
    return credentials;
  }

  /// Signs in with the provided [loginAccountDto].
  ///
  /// Throws a [LogInWithEmailAndPasswordFailure] if an exception occurs.
  Future<void> logInWithEmailAndPassword(
      {required LoginAccountDto loginAccountDto}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: loginAccountDto.emailAddress,
        password: loginAccountDto.password,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw LogInWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (error) {
      log.e(
        "AuthenticationRepository:logInWithEmailAndPassword Error",
        error: error,
      );

      throw const LogInWithEmailAndPasswordFailure();
    }
  }

  /// Signs out the current user.
  ///
  /// Throws a [LogOutException] if an exception occurs.
  Future<void> logOut() async {
    try {
      await _firebaseAuth.signOut();
      this._offlineAuthentication.clearStorage();
    } catch (_) {
      throw LogOutException();
    }
  }
}
