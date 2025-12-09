class BaseResponse<T> {
  final String status;
  final String responseCode;
  final String displayLoginForm;
  final String isVerified;
  final String msg;
  final T? data;

  BaseResponse({
    required this.status,
    required this.responseCode,
    required this.displayLoginForm,
    required this.isVerified,
    required this.msg,
    this.data,
  });

  /// Factory to handle dynamic JSON structure
  factory BaseResponse.fromJson(
      Map<String, dynamic> json, {
        T Function(Map<String, dynamic>)? fromJsonT,
      }) {
    T? parsedData;

    if (json['data'] != null) {
      if (fromJsonT != null && json['data'] is Map<String, dynamic>) {
        // ✅ Parse data using the provided model parser
        parsedData = fromJsonT(Map<String, dynamic>.from(json['data']));
      } else {
        // ✅ Fallback: keep as-is (e.g. raw map or list)
        parsedData = json['data'] as T?;
      }
    }

    return BaseResponse<T>(
      status: json['status']?.toString() ?? '0',
      responseCode: json['responseCode']?.toString() ?? '0',
      displayLoginForm: json['displayLoginForm']?.toString() ?? '0',
      isVerified: json['isVerified']?.toString() ?? '0',
      msg: json['msg']?.toString() ?? '',
      data: parsedData,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'responseCode': responseCode,
      'displayLoginForm': displayLoginForm,
      'isVerified': isVerified,
      'msg': msg,
      'data': (data is Map || data is List)
          ? data
          : (data != null
          ? (data as dynamic).toJson()
          : null),
    };
  }

  bool get isSuccess => status == '1';
}
