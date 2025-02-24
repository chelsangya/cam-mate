class ApiEndpoints {
  ApiEndpoints._();

  static const Duration connectionTimeout = Duration(seconds: 1000);
  static const Duration receiveTimeout = Duration(seconds: 1000);
  static const String baseUrl = "https://localhost:5800/api/";

  static const limitPage = 5;

  // ======================== Auth Routes ========================
  static const String login = "login";
  static const String register = "register";
}