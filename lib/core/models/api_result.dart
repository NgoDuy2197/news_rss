class ApiResult<T> {
  const ApiResult({required this.success, this.message, this.data});

  final bool success;
  final String? message;
  final T? data;
}
