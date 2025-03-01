class ApiEndpoints {
  ApiEndpoints._();

  static const Duration connectionTimeout = Duration(seconds: 1000);
  static const Duration receiveTimeout = Duration(seconds: 1000);
  static const String baseUrl = "http://localhost:8000/api/";

  static const limitPage = 5;

  // ======================== Auth Routes ========================
  static const String login = "login/";
  static const String register = "register";
  static const String verifyEmail = "verifyEmail";
  static const String updateUser = "updateUser";
  static const String editUserPassword = "updateUserPassword";
  static const String getUser = "getUser";
  static const String uploadProfileImage = "uploadProfileImage";
  // static const String
  static const String uploadProfilePicture = "uploadProfilePicture";
  static const String requestOTP = "requestOTP";
  static const String resetPassword = "resetPassword";
  static const String getUserById = "getUserById";
}
