import 'package:cammate/core/common/appbar/my_custom_appbar.dart';
import 'package:cammate/features/auth/presentation/view/profile_view.dart';
import 'package:flutter/material.dart';

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final List<Map<String, dynamic>> customers = [
    {
      'name': 'Eipstein John',
      'id': '12345',
      'purchaseDate': DateTime(2024, 10, 28),
      'totalPurchases': 30,
    },
    {
      'name': 'Alice Smith',
      'id': '67890',
      'purchaseDate': DateTime(2024, 10, 25),
      'totalPurchases': 15,
    },
    {
      'name': 'Bob Johnson',
      'id': '54321',
      'purchaseDate': DateTime(2024, 10, 27),
      'totalPurchases': 20,
    },
  ];

  List<Map<String, dynamic>> filteredCustomers = [];
  String searchQuery = '';
  String selectedSort = 'Recent Purchases';

  @override
  void initState() {
    super.initState();
    filteredCustomers = customers;
    sortCustomers();
  }

  void updateSearch(String query) {
    setState(() {
      searchQuery = query;
      filteredCustomers =
          customers
              .where(
                (customer) => customer['name']!.toLowerCase().contains(
                  query.toLowerCase(),
                ),
              )
              .toList();
      sortCustomers();
    });
  }

  void sortCustomers() {
    setState(() {
      switch (selectedSort) {
        case 'A-Z':
          filteredCustomers.sort((a, b) => a['name'].compareTo(b['name']));
          break;
        case 'Z-A':
          filteredCustomers.sort((a, b) => b['name'].compareTo(a['name']));
          break;
        case 'Recent Purchases':
          filteredCustomers.sort(
            (a, b) => b['purchaseDate'].compareTo(a['purchaseDate']),
          );
          break;
        case 'Most Sales':
          filteredCustomers.sort(
            (a, b) => b['totalPurchases'].compareTo(a['totalPurchases']),
          );
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myCustomAppBar(context, 'Customer List'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Search Customer',
                border: OutlineInputBorder(),
              ),
              onChanged: updateSearch,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Sort by:'),
                DropdownButton<String>(
                  value: selectedSort,
                  items:
                      ['Recent Purchases', 'A-Z', 'Z-A', 'Most Sales'].map((
                        String value,
                      ) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedSort = newValue!;
                      sortCustomers();
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: filteredCustomers.length,
                itemBuilder: (context, index) {
                  final customer = filteredCustomers[index];
                  return ListTile(
                    title: Text(customer['name']),
                    subtitle: Text('ID: ${customer['id']}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => ProfileView(
                              ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
