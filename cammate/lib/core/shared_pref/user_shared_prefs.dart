import 'dart:convert';

import 'package:cammate/core/failure/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final userSharedPrefsProvider = Provider.autoDispose<UserSharedPrefs>((ref) => UserSharedPrefs());

class UserSharedPrefs {
  static final UserSharedPrefs _instance = UserSharedPrefs._internal();
  factory UserSharedPrefs() => _instance;

  UserSharedPrefs._internal();

  late SharedPreferences _sharedPreferences;

  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<Either<Failure, bool>> setUserToken(String token) async {
    print('Setting User Token: $token');
    try {
      await _sharedPreferences.setString('token', token);
      return right(true);
    } catch (e) {
      return left(Failure(error: e.toString()));
    }
  }

 Future<Either<Failure, String?>> getUserToken() async {
    try {
      final token = _sharedPreferences.getString('token');
      return Right(token);
    } catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }

  Future<Either<Failure, bool>> deleteUserToken() async {
    try {
      await _sharedPreferences.remove('token');
      return right(true);
    } catch (e) {
      return left(Failure(error: e.toString()));
    }
  }

  Future<bool> setUser(Map<String, dynamic> user) async {
    try {
      String userDataString = jsonEncode(user);
      print('Storing User Data String: $userDataString');
      await _sharedPreferences.setString('user', userDataString);
      print('User data saved successfully.');
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>?> getUser() async {
    try {
      String? userDataString = _sharedPreferences.getString('user');
      print('Retrieved User Data String: $userDataString');

      if (userDataString == null || userDataString.isEmpty) {
        return null;
      }

      Map<String, dynamic> userData = jsonDecode(userDataString);
      return userData;
    } catch (e) {
      return null;
    }
  }

  Future<bool> deleteUser() async {
    try {
      await _sharedPreferences.remove('user');
      return true;
    } catch (e) {
      return false;
    }
  }
}
