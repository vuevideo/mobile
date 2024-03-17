import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:http/http.dart' as http;
import 'package:models/models.dart';
import 'package:user_repository/user_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

/// Mocks
import 'upload_profile_image_test.mocks.dart';

// Mock and Constant Testing Data
final String testingUrl = "https://testurl";
final String testingToken = "token";
final String mockUuid = "test_uuid";

final UpdateProfileImageDto mockDto = UpdateProfileImageDto(
  imageLink:
      "https://firebasestorage.googleapis.com/v0/b/some-bucket/o/profile-pictures/test_uuid.jpg",
  storageUuid: "test_uuid",
);

final ProfileImage mockProfileImage = ProfileImage(
  id: "test_id",
  imageLink: mockDto.imageLink,
  storageUuid: mockDto.storageUuid,
);

final File mockFile = File("test_file");

final Uri updateUserProfileImageUri =
    Uri.parse("$testingUrl/api/v1/user/profile-image");

final Map<String, String> _4xxErrorBody = {"message": "400 error"};
final Map<String, String> _5xxErrorBody = {"message": "500 error"};
final Map<String, String> testingHeaders = {
  'Authorization': 'Bearer $testingToken',
};

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
])
void main() {
  group('uploadProfileImage()', () {
    // Mocking Firebase calls
    final firebaseAuth = MockFirebaseAuth();
    final firebaseUser = MockUser();
    final firebaseStorage = MockFirebaseStorage();

    when(firebaseAuth.currentUser).thenReturn(firebaseUser);
    when(firebaseUser.getIdToken())
        .thenAnswer((_) => Future(() => testingToken));

    test('uploads profile image for an account with profile image', () async {
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
          updateUserProfileImageUri,
          body: mockDto.toJson(),
          headers: testingHeaders,
        ),
      ).thenAnswer(
        (_) async => http.Response(
            json.encode(
              mockProfileImage.toJson(),
            ),
            200),
      );

      // Act
      ProfileImage profileImage = await mockRepository.uploadProfileImage(
        profileImageFile: mockFile,
        account: mockAccountWithProfileImage,
        imageUuid: mockUuid,
      );

      // Assert
      expect(profileImage, isA<ProfileImage>());
      expect(profileImage.storageUuid, mockUuid);
      verify(client.put(
        updateUserProfileImageUri,
        body: mockDto.toJson(),
        headers: testingHeaders,
      )).called(1);
    });

    test('uploads profile image for an account without profile image', () async {
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
          updateUserProfileImageUri,
          body: mockDto.toJson(),
          headers: testingHeaders,
        ),
      ).thenAnswer(
            (_) async => http.Response(
            json.encode(
              mockProfileImage.toJson(),
            ),
            200),
      );

      // Act
      ProfileImage profileImage = await mockRepository.uploadProfileImage(
        profileImageFile: mockFile,
        account: mockAccountWithoutProfileImage,
        imageUuid: mockUuid,
      );

      // Assert
      expect(profileImage, isA<ProfileImage>());
      expect(profileImage.storageUuid, mockUuid);
      verify(client.put(
        updateUserProfileImageUri,
        body: mockDto.toJson(),
        headers: testingHeaders,
      )).called(1);
    });
  });
}
