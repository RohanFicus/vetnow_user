class ApiResponse<T, M> {
  final bool status;
  final String message;
  final T? data;
  final M? meta;

  ApiResponse({
    required this.status,
    required this.message,
    this.data,
    this.meta,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json)? fromJsonT,
    M Function(dynamic json)? fromJsonM,
  ) {
    return ApiResponse<T, M>(
      status: json['status'] as bool,
      message: json['message'] as String,
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : null,
      meta: json['meta'] != null && fromJsonM != null
          ? fromJsonM(json['meta'])
          : null,
    );
  }
}
