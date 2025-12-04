import 'package:cammate/core/common/appbar/my_custom_appbar.dart';
import 'package:flutter/material.dart';

class UsersView extends StatefulWidget {
  const UsersView({super.key});

  @override
  State<UsersView> createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myCustomAppBar(context, 'Project Zero'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListView(
                        shrinkWrap: true,
                        children: const [
                          ListTile(
                            leading: Icon(
                              Icons.people,
                              size: 30,
                              color: Colors.blueGrey,
                            ),
                            title: Text(
                              'Customers inside',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                              '12',
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(0xFF0B2B3D),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Divider(),
                          ListTile(
                            leading: Icon(
                              Icons.person,
                              size: 30,
                              color: Colors.indigo,
                            ),
                            title: Text(
                              'Staffs present',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                              '12',
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(0xFF0B2B3D),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Divider(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: StatCard(
                      icon: Icons.shopify_outlined,
                      title: 'Time Spent',
                      value: '3 minutes avg.',
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      icon: Icons.vertical_split_rounded,
                      title: 'Total Visits',
                      value: '300 per day',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: StatCard(
                      icon: Icons.commute,
                      title: 'Parking Spots',
                      value: '5 available',
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      icon: Icons.notifications,
                      title: 'Notifications',
                      value: '5 new alerts',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const StatCard({
    required this.icon,
    required this.title,
    required this.value,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: const Color(0xFF0B2B3D)),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(value, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
