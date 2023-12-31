import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:authentication_repository/authentication_repository.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// Repository Implementation for User Registration, Login and Logout.
class AuthenticationRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final String _apiUrl;

  AuthenticationRepository({
    required firebase_auth.FirebaseAuth firebaseAuth,
    required String apiUrl,
  })  : _firebaseAuth = firebaseAuth,
        _apiUrl = apiUrl;

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

  /// Register a new account using [emailAddress] and [password].
  ///
  /// Throws [ServerException] if any errors according to the server.
  Future<Credentials> registerWithEmailAndPassword({
    required String emailAddress,
    required String password,
  }) async {
    // Prepare URI for the request.
    Uri uri = Uri.parse("$_apiUrl/doctor/specialization");

    // Prepare authorization headers.
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    // Send the post request to the server.
    http.Response response = await http.post(
      uri,
      headers: headers,
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

  /// Signs in with the provided [emailAddress] and [password].
  ///
  /// Throws a [LogInWithEmailAndPasswordFailure] if an exception occurs.
  Future<void> logInWithEmailAndPassword({
    required String emailAddress,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
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
}
