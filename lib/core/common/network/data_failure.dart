class DataFailure {
  int statusCode;
  String message;
  DataFailure({
    this.statusCode = 400,
    this.message = 'An error occurred. Try again later',
  });

  DataFailure copyWith({int? statusCode, String? message, dynamic data}) {
    return DataFailure(
      statusCode: statusCode ?? this.statusCode,
      message: message ?? this.message,
    );
  }
}
