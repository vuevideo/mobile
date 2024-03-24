import 'dart:io';
import 'package:meta/meta.dart';

import 'package:user_repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:models/models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:log/log.dart';

/// Repository implementation for Updating and Deleting User Details.
class UserRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final firebase_storage.FirebaseStorage _firebaseStorage;
  final String _apiUrl;
  final http.Client _client;

  const UserRepository({
    required firebase_auth.FirebaseAuth firebaseAuth,
    required firebase_storage.FirebaseStorage firebaseStorage,
    required String apiUrl,
    required http.Client client,
  })  : this._firebaseAuth = firebaseAuth,
        this._firebaseStorage = firebaseStorage,
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
    Account account = Account.fromJson(jsonResponse);

    // Return account.
    return account;
  }

  /// Upload user profile image passed by [profileImageFile]
  ///
  /// Throws [ServerException] if any errors according to the server.
  Future<ProfileImage> uploadProfileImage({
    required File profileImageFile,
    required Account account,
    required String imageUuid,
  }) async {
    try {
      // Upload File into firebase storage.
      final firebase_storage.Reference profilePictureRef =
          this._firebaseStorage.ref(
                "profile-pictures",
              );

      final firebase_storage.Reference uploadImageRef = profilePictureRef.child(
        "/$imageUuid.jpg",
      );

      await uploadImageRef.putFile(profileImageFile);

      // Generated public URL for the uploaded image.
      String publicUrl = await uploadImageRef.getDownloadURL();

      ProfileImage profileImage = await this.updateProfileImage(
        updateProfileImageDto: UpdateProfileImageDto(
          imageLink: publicUrl,
          storageUuid: imageUuid,
        ),
      );

      // Delete previous profile image if it exists.
      if (account.image.storageUuid != "")
        await deleteProfileImage(
          account: account,
        );

      // Return profile image.
      return profileImage;
    } catch (error, stackTrace) {
      log.e(
        "UserRepository:uploadProfileImage",
        error: error,
        stackTrace: stackTrace,
      );

      throw ServerException();
    }
  }

  /// Upload user email address passed by [updateEmailDto]
  ///
  /// Throws [UpdateEmailAddressFailure] if any errors according to the server.
  Future<void> updateEmailAddress({
    required UpdateEmailDto updateEmailDto,
    required String password,
  }) async {
    try {
      firebase_auth.User? loggedInUser = await this._firebaseAuth.currentUser;

      if (loggedInUser != null) {
        firebase_auth.AuthCredential authCredential =
            firebase_auth.EmailAuthProvider.credential(
          email: loggedInUser.email!,
          password: password,
        );

        await loggedInUser.reauthenticateWithCredential(
          authCredential,
        );

        await loggedInUser.verifyBeforeUpdateEmail(
          updateEmailDto.emailAddress,
        );
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw UpdateEmailAddressFailure.fromCode(e.code);
    } catch (error) {
      log.e(
        "UserRepository:updateEmailAddress Error",
        error: error,
      );

      throw const UpdateEmailAddressFailure();
    }
  }

  /// Upload user password passed by [updatePasswordDto]
  ///
  /// Throws [UpdatePasswordFailure] if any errors according to the server.
  Future<void> updatePassword({
    required UpdatePasswordDto updatePasswordDto,
  }) async {
    try {
      firebase_auth.User? loggedInUser = await this._firebaseAuth.currentUser;

      if (loggedInUser != null) {
        firebase_auth.AuthCredential authCredential =
            firebase_auth.EmailAuthProvider.credential(
          email: loggedInUser.email!,
          password: updatePasswordDto.oldPassword,
        );

        await loggedInUser.reauthenticateWithCredential(
          authCredential,
        );

        await loggedInUser.updatePassword(
          updatePasswordDto.newPassword,
        );
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw UpdatePasswordFailure.fromCode(e.code);
    } catch (error) {
      log.e(
        "UserRepository:updatePassword Error",
        error: error,
      );

      throw const UpdatePasswordFailure();
    }
  }

  /// Update user profile image using [updateProfileImageDto].
  ///
  /// Throws [ServerException] if any errors according to the server.
  @visibleForTesting
  Future<ProfileImage> updateProfileImage({
    required UpdateProfileImageDto updateProfileImageDto,
  }) async {
    // Prepare URI for the request.
    Uri uri = Uri.parse("$_apiUrl/api/v1/user/profile-image");

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
      body: updateProfileImageDto.toJson(),
      headers: headers,
    );

    // Check for any errors.
    _validateRequestAndThrowError(
      response: response,
      errorLogName: "UserRepository:updateProfileImage",
    );

    // Decode JSON and create object based on it.
    dynamic jsonResponse = json.decode(response.body);
    ProfileImage profileImage = ProfileImage.fromJson(jsonResponse);

    // Return Profile Image.
    return profileImage;
  }

  /// Delete user profile image using [user].
  ///
  /// Throws [ServerException] if any errors according to the server.
  @visibleForTesting
  Future<void> deleteProfileImage({
    required Account account,
  }) async {
    try {
      // Fetch Image UUID for the user.
      String storageUUID = account.image.storageUuid;

      if (storageUUID != "") {
        // Delete firebase image from storage.
        firebase_storage.Reference profilePictureRef =
            this._firebaseStorage.ref(
                  "profile-pictures/$storageUUID.jpg",
                );
        await profilePictureRef.delete();
      }
    } catch (error, stackTrace) {
      log.e(
        "UserRepository:deleteProfileImage",
        error: error,
        stackTrace: stackTrace,
      );

      throw ServerException();
    }
  }
}
