abstract class RequestException implements Exception {
  final String message;
  final int statusCode;

  const RequestException(this.message, this.statusCode);
}

class BadRequest<T> implements RequestException {
  @override
  final String message;

  @override
  final int statusCode = 400;
  final T? data;

  BadRequest({
    this.message = 'Bad request: Client send wrong data',
    this.data,
  });

  @override
  String toString() => '$message, $data';
}
