class ApiEndpoints {
  ApiEndpoints._();

  static const Duration connectionTimeout = Duration(seconds: 1000);
  static const Duration receiveTimeout = Duration(seconds: 1000);

  static const String baseUrl = "http://localhost:8000";

  // Auth
  static const String authBase = "/auth";
  static const String login = "$authBase/login";
  static const String loginJson = "$authBase/login-json";
  static const String verifyToken = "$authBase/verify-token";
  static const String logout = "$authBase/logout";
  static const String me = "$authBase/me";
  static const String refreshToken = "$authBase/refresh-token";
  static const String forgotPassword = "$authBase/forgot-password";
  static const String resetPassword = "$authBase/reset-password";
  static const String changePassword = "$authBase/change-password";
  static const String validateSession = "$authBase/validate-session";

  // Users
  static const String usersBase = "/user";
  static const String createUser = "$usersBase/";
  static const String getUsers = "$usersBase/";
  static String getUserById(String id) => "$usersBase/$id";
  static String updateUser(String id) => "$usersBase/$id";

  // Marts
  static const String martsBase = "/marts";
  static const String createMart = "$martsBase/";
  static const String getMarts = "$martsBase/";
  static String getMart(String id) => "$martsBase/$id";
  static String updateMart(String id) => "$martsBase/$id";
  static String deleteMart(String id) => "$martsBase/$id";

  // Cameras
  static const String camerasBase = "/cameras";
  static const String getCameras = "$camerasBase/";
  static const String createCamera = "$camerasBase/";
  static const String cameraStats = "$camerasBase/stats";
  static String getCamera(String id) => "$camerasBase/$id";
  static String updateCamera(String id) => "$camerasBase/$id";
  static String deleteCamera(String id) => "$camerasBase/$id";

  // Activities
  static const String activitiesBase = "/activities";
  static const String getActivities = "$activitiesBase/";
  static const String createActivity = "$activitiesBase/";
  static const String activityStats = "$activitiesBase/stats";
  static String getActivity(String id) => "$activitiesBase/$id";
  static String updateActivity(String id) => "$activitiesBase/$id";
  static String deleteActivity(String id) => "$activitiesBase/$id";

  // Misc
  static const String root = "/";
  static const String health = "/health";
  static const String debugDbCheck = "/debug/db-check";
  static const String debugConfig = "/debug/config";

  static const int limitPage = 5;
}
