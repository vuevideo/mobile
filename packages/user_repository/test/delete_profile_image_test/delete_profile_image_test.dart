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
import 'delete_profile_image_test.mocks.dart';

// Mock and Constant Testing Data
final String testingUrl = "https://testurl";

Account mockAccountWithProfileImage = Account(
  id: "test_id",
  name: "test_name",
  username: "test_username",
  image: ProfileImage(
    id: "test_id",
    imageLink: "test_link",
    storageUuid: "test_uuid",
  ),
);

Account mockAccountWithoutProfileImage = Account(
  id: "test_id",
  name: "test_name",
  username: "test_username",
  image: ProfileImage(
    id: "",
    imageLink: "",
    storageUuid: "",
  ),
);

@GenerateMocks([
  http.Client,
  firebase_auth.FirebaseAuth,
  firebase_auth.User,
  firebase_storage.FirebaseStorage,
  firebase_storage.Reference,
])
void main() {
  group('deleteProfileImage()', () {
    // Mocking Firebase Storage calls
    final firebaseAuth = MockFirebaseAuth();
    final firebaseStorageReference = MockReference();
    final firebaseStorage = MockFirebaseStorage();

    test('deletes profile image for an account with profile image', () async {
      // Arrange
      final client = MockClient();
      UserRepository mockRepository = UserRepository(
        firebaseAuth: firebaseAuth,
        apiUrl: testingUrl,
        client: client,
        firebaseStorage: firebaseStorage,
      );

      when(
        firebaseStorage.ref(
          "profile-pictures/${mockAccountWithProfileImage.image.storageUuid}.jpg",
        ),
      ).thenReturn(firebaseStorageReference);

      when(firebaseStorageReference.delete()).thenAnswer(
        (_) => Future(() => null),
      );

      // Act and Assert
      await mockRepository.deleteProfileImage(
        account: mockAccountWithProfileImage,
      );
    });

    test('skips deleting profile image for an account without profile image',
        () async {
      // Arrange
      final client = MockClient();
      UserRepository mockRepository = UserRepository(
        firebaseAuth: firebaseAuth,
        apiUrl: testingUrl,
        client: client,
        firebaseStorage: firebaseStorage,
      );

      // Act and Assert
      await mockRepository.deleteProfileImage(
        account: mockAccountWithoutProfileImage,
      );
    });

    test('handles Firebase Storage Error', () async {
      // Arrange
      final client = MockClient();
      UserRepository mockRepository = UserRepository(
        firebaseAuth: firebaseAuth,
        apiUrl: testingUrl,
        client: client,
        firebaseStorage: firebaseStorage,
      );

      when(
        firebaseStorage.ref(
          "profile-pictures/${mockAccountWithProfileImage.image.storageUuid}.jpg",
        ),
      ).thenReturn(firebaseStorageReference);

      when(firebaseStorageReference.delete()).thenThrow(
        firebase_storage.FirebaseException,
      );

      expect(
        // Act
        () async => await mockRepository.deleteProfileImage(
          account: mockAccountWithProfileImage,
        ),
        // Assert
        throwsA(isA<ServerException>()),
      );
    });
  });
}
