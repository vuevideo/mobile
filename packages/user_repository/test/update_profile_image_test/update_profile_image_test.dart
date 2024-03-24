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
import 'update_profile_image_test.mocks.dart';

// Mock and Constant Testing Data
final String testingUrl = "https://testurl";
final String testingToken = "token";

final UpdateProfileImageDto mockDto = UpdateProfileImageDto(
  imageLink: "test_link",
  storageUuid: "test_uuid",
);

final ProfileImage mockProfileImage = ProfileImage(
  id: "test_id",
  imageLink: mockDto.imageLink,
  storageUuid: mockDto.storageUuid,
);

final Uri updateUserProfileImageUri =
    Uri.parse("$testingUrl/api/v1/user/profile-image");

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
  group('updateProfileImage()', () {
    // Mocking Firebase Auth calls
    final firebaseAuth = MockFirebaseAuth();
    final firebaseUser = MockUser();
    final firebaseStorage = MockFirebaseStorage();

    when(firebaseAuth.currentUser).thenReturn(firebaseUser);
    when(firebaseUser.getIdToken())
        .thenAnswer((_) => Future(() => testingToken));

    test('returns an updated profile image for proper details passed as DTO',
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
      ProfileImage profileImage = await mockRepository.updateProfileImage(
        updateProfileImageDto: mockDto,
      );

      // Assert
      expect(profileImage, isA<ProfileImage>());
      expect(profileImage.imageLink, equals(mockDto.imageLink));
      expect(profileImage.storageUuid, equals(mockDto.storageUuid));
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
          updateUserProfileImageUri,
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
        () async => await mockRepository.updateProfileImage(
          updateProfileImageDto: mockDto,
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
          updateUserProfileImageUri,
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
        () async => await mockRepository.updateProfileImage(
          updateProfileImageDto: mockDto,
        ),
        // Assert
        throwsA(isA<ServerException>()),
      );
    });
  });
}
