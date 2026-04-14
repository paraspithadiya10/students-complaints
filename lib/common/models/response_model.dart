class ResponseModel {
  final dynamic data;
  final String message;
  final ResponseType type;
  final dynamic error;

  const ResponseModel({
    this.data,
    this.message = '',
    this.type = ResponseType.success,
    this.error,
  });
}

enum ResponseType { success, exception, networkError, error }
