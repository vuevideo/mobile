class UpdateEmailAddressFailure implements Exception {
  const UpdateEmailAddressFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  /// Create an authentication message
  /// from a firebase authentication exception code.
  factory UpdateEmailAddressFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const UpdateEmailAddressFailure(
          'Email is not valid or badly formatted.',
        );
      case 'email-already-in-use':
        return const UpdateEmailAddressFailure(
          'This user has been disabled. Please contact support for help.',
        );
      case 'user-not-found':
        return const UpdateEmailAddressFailure(
          'Email is not found, please create an account.',
        );
      case 'wrong-password':
        return const UpdateEmailAddressFailure(
          'Incorrect password, please try again.',
        );
      default:
        return const UpdateEmailAddressFailure();
    }
  }

  /// Error message.
  final String message;
}