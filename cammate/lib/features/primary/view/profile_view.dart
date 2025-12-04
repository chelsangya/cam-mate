import 'package:cammate/core/common/appbar/my_custom_appbar.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  final String name;
  final String customerId;

  const ProfileView({super.key, required this.name, required this.customerId});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myCustomAppBar(context, 'Customer Profile'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundColor: Colors.indigo,
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 10),
              Text(
                widget.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Customer ID: ${widget.customerId}',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              _buildSectionHeader('Purchase Summary'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildProfileStatCard('Total Purchases', '30 items'),
                  _buildProfileStatCard('Total Spend', '\$450'),
                ],
              ),
              const SizedBox(height: 20),
              _buildSectionHeader('Favorite Categories'),
              const Wrap(
                spacing: 8.0,
                children: [
                  Chip(label: Text('Groceries')),
                  Chip(label: Text('Electronics')),
                  Chip(label: Text('Clothing')),
                ],
              ),
              const SizedBox(height: 20),
              _buildSectionHeader('Recent Purchases'),
              _buildPurchaseCard('Milk', '\$3.50', '2 days ago'),
              _buildPurchaseCard('Smartphone', '\$299', '5 days ago'),
              _buildPurchaseCard('Jeans', '\$40', '1 week ago'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.indigo,
      ),
    );
  }

  Widget _buildProfileStatCard(String title, String value) {
    return Expanded(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(value, style: const TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPurchaseCard(String item, String price, String date) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: const Icon(Icons.shopping_bag, color: Colors.indigo),
        title: Text(item, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(price),
        trailing: Text(date, style: const TextStyle(color: Colors.grey)),
      ),
    );
  }
}
