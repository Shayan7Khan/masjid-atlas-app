class RequestResponse {
  late bool success;
  String? error;
  late Map<String, dynamic> data;

  RequestResponse(this.success, {this.error}) {
    data = {};
  }

  RequestResponse.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      data = json;
      final dynamic s = json['success'];
      success = s is bool ? s : true; // Default to true for third‑party APIs
      error = json['error']?.toString();
    } else {
      // Fallback for unexpected response shapes
      data = {'body': json};
      success = true;
      error = null;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'error': error,
      'body': data,
    };
  }
}
