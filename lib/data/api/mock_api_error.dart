/// Typed error for mock API failures, mirroring the reference MockApiError.
class MockApiError implements Exception {
  const MockApiError(this.message, {required this.status, required this.code});

  final String message;

  /// HTTP-like status code (404, 422, 503).
  final int status;

  /// Machine-readable error code (e.g. 'RESIDENT_NOT_FOUND').
  final String code;

  @override
  String toString() => 'MockApiError($status $code): $message';
}
