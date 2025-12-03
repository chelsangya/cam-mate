import 'package:cammate/config/api_endpoints.dart';
import 'package:cammate/config/approutes.dart';
import 'package:cammate/core/shared_pref/user_shared_prefs.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);

    _controller.forward();

    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        await _handleNavigation();
      }
    });
  }

  Future<void> _handleNavigation() async {
    String? token;
    final data = await UserSharedPrefs().getUserToken();
    if (data.isRight()) {
      token = data.getOrElse(() => null);
    }

    if (token == null) {
      _navigateToLogin();
      return;
    }

    // Check if token is expired
    if (JwtDecoder.isExpired(token)) {
      // Try to refresh token
      final refreshResult = await _refreshToken(token);
      if (!refreshResult) {
        _navigateToLogin();
        return;
      }
    }

    // Token exists and is valid
    _navigateToHome();
  }

  Future<bool> _refreshToken(String expiredToken) async {
    try {
      final refreshTokenData = {"refresh_token": expiredToken};
      final response = await dio.post(
        ApiEndpoints.refreshToken,
        data: refreshTokenData,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200 && response.data['access_token'] != null) {
        final newToken = response.data['access_token'];
        await UserSharedPrefs().setUserToken(newToken);
        return true;
      }
      return false;
    } catch (e) {
      print("Token refresh failed: $e");
      return false;
    }
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacementNamed(AppRoute.loginRoute);
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacementNamed(AppRoute.homeRoute);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _animation,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(color: const Color(0xFF212121)),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Image.asset('assets/images/logo.png'),
                ),
              ),
            ),
            const Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'Monitoring Your Security',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
