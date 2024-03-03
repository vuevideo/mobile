import 'package:user_repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:models/models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:log/log.dart';

/// Repository implementation for Updating and Deleting User Details.
class UserRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final String _apiUrl;
  final http.Client _client;

  const UserRepository({
    required firebase_auth.FirebaseAuth firebaseAuth,
    required String apiUrl,
    required http.Client client,
  })  : this._firebaseAuth = firebaseAuth,
        this._apiUrl = apiUrl,
        this._client = client;

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

  /// Update user account details using [updateUserDto].
  ///
  /// Throws [ServerException] if any errors according to the server.
  Future<Account> updateUserDetails({
    required UpdateUserDto updateUserDto,
  }) async {
    // Prepare URI for the request.
    Uri uri = Uri.parse("$_apiUrl/api/v1/user");

    // Fetch the ID token for the user.
    String? firebaseAuthToken =
        await this._firebaseAuth.currentUser!.getIdToken();

    // Prepare authorization headers.
    Map<String, String> headers = {
      'Authorization': 'Bearer $firebaseAuthToken',
    };

    // Send the put request to the server.
    http.Response response = await _client.put(
      uri,
      body: updateUserDto.toJson(),
      headers: headers,
    );

    // Check for any errors.
    _validateRequestAndThrowError(
      response: response,
      errorLogName: "UserRepository:updateUserDetails",
    );

    // Decode JSON and create object based on it.
    dynamic jsonResponse = json.decode(response.body);
    log.i(jsonResponse);
    Account account = Account.fromJson(jsonResponse);

    // Return account.
    return account;
  }
}
