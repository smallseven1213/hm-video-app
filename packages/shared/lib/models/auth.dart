enum ResponseStatus { success, failed }

class HttpResult {
  final ResponseStatus status;
  final String? message;

  HttpResult({
    required this.status,
    this.message,
  });
}
