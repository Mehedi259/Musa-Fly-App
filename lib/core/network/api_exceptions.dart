class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

class NetworkException extends ApiException {
  NetworkException([super.message = 'No internet connection. Please check your network.']);
}

class ServerException extends ApiException {
  ServerException([super.message = 'Server error occurred. Please try again later.', super.statusCode]);
}

class NotFoundException extends ApiException {
  NotFoundException([super.message = 'The requested resource was not found.', super.statusCode]);
}

class TimeoutException extends ApiException {
  TimeoutException([super.message = 'Connection timed out. Please try again.']);
}
