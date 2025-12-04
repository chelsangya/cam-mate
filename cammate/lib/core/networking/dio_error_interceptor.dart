import 'package:dio/dio.dart';

class DioErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Safely extract a user-friendly message from the response if available.
    String extractMessage(Response? response) {
      if (response == null) return 'Connection error!';
      try {
        final data = response.data;
        if (data is Map && data.containsKey('message') && data['message'] != null) {
          return data['message'].toString();
        }
        if (response.statusMessage != null && response.statusMessage!.isNotEmpty) {
          return response.statusMessage!;
        }
        // Fallback to the response body string
        return data?.toString() ?? 'Something went wrong';
      } catch (_) {
        // Defensive fallback if response.data isn't indexable
        return response.statusMessage ?? 'Something went wrong';
      }
    }

    if (err.response != null) {
      final message = extractMessage(err.response);
      err = DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        error: message,
        type: err.type,
      );
    } else {
      err = DioException(
        requestOptions: err.requestOptions,
        error: 'Connection error!',
        type: err.type,
      );
    }
    super.onError(err, handler);
  }
}
