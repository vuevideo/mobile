import 'package:http/http.dart' as http;
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart' as fa_mocks;
import 'package:user_repository/user_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

/// Mocks
import 'update_email_address_test.mocks.dart';

// Mock and Constant Testing Data
final String testingUrl = "https://testurl";

final UpdateEmailDto mockDto = UpdateEmailDto(emailAddress: 'test@email.com');

@GenerateMocks([
  http.Client,
  firebase_storage.FirebaseStorage,
])
void main() {
  group('updateEmailAddress()', () {
    // Mocking Firebase Auth calls
    final firebaseAuth = fa_mocks.MockFirebaseAuth();
    final firebaseStorage = MockFirebaseStorage();

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

      // Act and assert
      await mockRepository.updateEmailAddress(
        updateEmailDto: mockDto,
        password: 'test_password',
      );
    });
  });
}
