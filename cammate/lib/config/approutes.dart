import 'package:cammate/features/auth/presentation/view/login_view.dart';
import 'package:cammate/features/primary/view/customer_list.dart';
import 'package:cammate/features/primary/view/primary_view.dart';
import 'package:cammate/features/splash/presentation/view/splash_view.dart';

class AppRoute {
  static const String homeRoute = '/';
  static const String selectRoute = '/select';

  static const String loginRoute = '/login';
  // static const String signinRoute = '/register';
  static const String profileRoute = '/profile';
  static const String userListRoute = '/profile';
  static const String settingsRoute = '/settings';
  static const String splashRoute = '/splash';
  static const String verifyEmailRoute= '/verifyEmail';
  static getApplicationRoute() {
    return {
      homeRoute: (context) => const PrimaryView(),
      // signinRoute: (context) => const RegisterView(),
      userListRoute: (context) => const UserList(),
      loginRoute: (context) => const LoginView(),
      splashRoute: (context) => const SplashView(),
      verifyEmailRoute: (context) => const PrimaryView(),
    };
  }
}
