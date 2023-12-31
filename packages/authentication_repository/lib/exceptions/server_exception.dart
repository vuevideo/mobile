class ServerException implements Exception {
  /// Error message.
  final String message;

  const ServerException({
    this.message = "An unknown exception occurred.",
  });
}
