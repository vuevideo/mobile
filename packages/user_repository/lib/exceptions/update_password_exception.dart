class UpdatePasswordFailure implements Exception {
  const UpdatePasswordFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  /// Create an authentication message
  /// from a firebase authentication exception code.
  factory UpdatePasswordFailure.fromCode(String code) {
    switch (code) {
      case 'weak-password':
        return const UpdatePasswordFailure(
          'The new password is a weak password.',
        );
      case 'wrong-password':
        return const UpdatePasswordFailure(
          'Incorrect password, please try again.',
        );
      default:
        return const UpdatePasswordFailure();
    }
  }

  /// Error message.
  final String message;
}