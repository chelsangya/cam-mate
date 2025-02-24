import 'package:flutter/material.dart';

AppBar myCustomAppBar(BuildContext context, String text) {
  final bool isDashboardPage = text == 'Project Zero';
  final bool isLiveView = text == 'Live View';
  final bool isUserPage = text == 'Customer List';
  final bool isSettingsPage = text == 'Profile';

  return AppBar(
    backgroundColor: const Color(0xFF0B2B3D),
    foregroundColor: Colors.white,
    leading: (isDashboardPage || isLiveView || isUserPage || isSettingsPage)
        ? const Text(
            '',
            style: TextStyle(
              color: Color(0xFF0B2B3D),
            ),
          )
        : IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
    title: Text(
      text,
      style: const TextStyle(color: Colors.white),
    ),
    centerTitle: true,
    elevation: 0,
    actions: [
      IconButton(
        icon: const Icon(Icons.notifications, color: Colors.white, size: 30),
        onPressed: () {},
      ),
    ],
  );
}
