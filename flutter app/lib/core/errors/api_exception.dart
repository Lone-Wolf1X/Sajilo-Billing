class ApiException implements Exception {
  final String code;
  final String message;
  final int? statusCode;
  final String? correlationId;

  ApiException({
    required this.code,
    required this.message,
    this.statusCode,
    this.correlationId,
  });

  @override
  String toString() => 'ApiException($code, $statusCode): $message';

  factory ApiException.fromResponse(Map<String, dynamic> body, int? statusCode) {
    return ApiException(
      code: body['code'] as String? ?? 'UNKNOWN',
      message: body['message'] as String? ?? 'Unexpected error',
      statusCode: statusCode,
      correlationId: body['correlationId'] as String?,
    );
  }

  factory ApiException.network() => ApiException(
        code: 'NETWORK_ERROR',
        message: 'Cannot reach server. Check that backend is running.',
      );

  factory ApiException.unauthorized() => ApiException(
        code: 'UNAUTHORIZED',
        message: 'Session expired. Please log in again.',
        statusCode: 401,
      );

  bool get isUnauthorized => statusCode == 401;
  bool get isForbidden => statusCode == 403;
  bool get isNetworkError => code == 'NETWORK_ERROR';
}

