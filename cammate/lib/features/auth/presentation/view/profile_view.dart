import 'package:cammate/core/common/appbar/my_custom_appbar.dart';
import 'package:cammate/core/shared_pref/user_shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  UserSharedPrefs userSharedPrefs = UserSharedPrefs();
  Map<String, dynamic>? user;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<void> getUser() async {
    Map<String, dynamic>? userData = await userSharedPrefs.getUser();
    setState(() {
      user = userData;
    });
  }

  Future<void> logout(BuildContext context) async {
    bool confirmLogout = await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Row(
              children: [
                Icon(Icons.logout, color: Colors.red),
                SizedBox(width: 10),
                Text('Logout', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            content: Text(
              'Are you sure you want to log out?',
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  await userSharedPrefs.deleteUserToken();
                  await userSharedPrefs.deleteUser();
                  Navigator.pop(context, true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Logout', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
    );

    if (confirmLogout == true) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myCustomAppBar(context, 'Profile Details'),
      body:
          user == null
              ? Center(child: CircularProgressIndicator())
              : Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        color: Colors.red,
                        icon: Icon(
                          Icons.logout_outlined,
                          // color: Colors.red,
                          size: 30,
                        ),
                        onPressed: () => logout(context),
                        style: ButtonStyle(
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: Colors.red[300]!),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(color: Colors.grey),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.blueAccent,
                              child: Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 15),
                            Text(
                              user!['email'] ?? 'No email',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Chip(
                                  label: Text(
                                    user!['is_active'] ? 'Active' : 'Inactive',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor:
                                      user!['is_active']
                                          ? Colors.green
                                          : Colors.red,
                                ),
                                SizedBox(width: 10),
                                if (user!['is_superuser'])
                                  Chip(
                                    label: Text(
                                      'Admin',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.blue,
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed:
                          () => Navigator.pushNamed(context, '/update-profile'),
                      icon: Icon(Icons.edit, color: Colors.white),
                      label: Text(
                        'Update Details',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed:
                          () => Navigator.pushNamed(context, '/update-profile'),
                      icon: Icon(Icons.lock, color: Colors.white),
                      label: Text(
                        'Change Password',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
