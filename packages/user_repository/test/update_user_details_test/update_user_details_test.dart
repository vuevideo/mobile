import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:models/models.dart';
import 'package:user_repository/user_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


/// Mocks
import 'update_user_details_test.mocks.dart';

// Mock and Constant Testing Data
final String testingUrl = "https://testurl";
final String testingToken = "token";

final UpdateUserDto mockDto = UpdateUserDto(
  username: 'new_username',
  name: 'new_name',
);

final Account mockAccount = new Account(
  id: 'id',
  name: 'new_name',
  username: 'new_username',
);

final Uri updateUserDetailsUri = Uri.parse("$testingUrl/api/v1/user");

final Map<String, String> _4xxErrorBody = {"message": "400 error"};
final Map<String, String> _5xxErrorBody = {"message": "500 error"};
final Map<String, String> testingHeaders = {
  'Authorization': 'Bearer $testingToken',
};

@GenerateMocks([
  http.Client,
  firebase_auth.FirebaseAuth,
  firebase_auth.User,
  firebase_storage.FirebaseStorage,
])
void main() {
  group('updateUserDetails()', () {

    // Mocking Firebase Auth calls
    final firebaseAuth = MockFirebaseAuth();
    final firebaseUser = MockUser();
    final firebaseStorage = MockFirebaseStorage();

    when(firebaseAuth.currentUser).thenReturn(firebaseUser);
    when(firebaseUser.getIdToken())
        .thenAnswer((_) => Future(() => testingToken));

    test('returns an updated account for proper details passed as DTO',
        () async {
      // Arrange
      final client = MockClient();
      UserRepository mockRepository = UserRepository(
        firebaseAuth: firebaseAuth,
        apiUrl: testingUrl,
        client: client,
        firebaseStorage: firebaseStorage,
      );

      when(
        client.put(
          updateUserDetailsUri,
          body: mockDto.toJson(),
          headers: testingHeaders,
        ),
      ).thenAnswer(
        (_) async => http.Response(
            json.encode(
              mockAccount.toJson(),
            ),
            200),
      );

      // Act
      Account account = await mockRepository.updateUserDetails(
        updateUserDto: mockDto,
      );

      // Assert
      expect(account, isA<Account>());
      expect(account.username, equals(mockDto.username));
      expect(account.name, equals(mockDto.name));
    });

    test('returns a server exception for the 4xx error code', () async {
      // Arrange
      final client = MockClient();
      UserRepository mockRepository = UserRepository(
        firebaseAuth: firebaseAuth,
        apiUrl: testingUrl,
        client: client,
        firebaseStorage: firebaseStorage,
      );
      when(
        client.put(
          updateUserDetailsUri,
          body: mockDto.toJson(),
          headers: testingHeaders,
        ),
      ).thenAnswer(
        (_) async => http.Response(
            json.encode(
              _4xxErrorBody,
            ),
            401),
      );

      expect(
        // Act
        () async => await mockRepository.updateUserDetails(
          updateUserDto: mockDto,
        ),
        // Assert
        throwsA(isA<ServerException>()),
      );
    });

    test('returns a server exception for the 5xx error code', () async {
      // Arrange
      final client = MockClient();
      UserRepository mockRepository = UserRepository(
        firebaseAuth: firebaseAuth,
        apiUrl: testingUrl,
        client: client,
        firebaseStorage: firebaseStorage,
      );
      when(
        client.put(
          updateUserDetailsUri,
          body: mockDto.toJson(),
          headers: testingHeaders,
        ),
      ).thenAnswer(
        (_) async => http.Response(
            json.encode(
              _5xxErrorBody,
            ),
            500),
      );

      expect(
        // Act
        () async => await mockRepository.updateUserDetails(
          updateUserDto: mockDto,
        ),
        // Assert
        throwsA(isA<ServerException>()),
      );
    });
  });
}
