import 'package:cammate/core/app.dart';
import 'package:cammate/core/shared_pref/user_shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserSharedPrefs().init();
  runApp(const ProviderScope(child: App()));
}
