import 'package:cammate/core/common/appbar/my_custom_appbar.dart';
import 'package:cammate/features/mart/data/model/mart_model.dart';
import 'package:flutter/material.dart';

class MartDetailView extends StatelessWidget {
  final MartAPIModel mart;
  const MartDetailView({super.key, required this.mart});

  Widget _infoRow(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.black45),
          const SizedBox(width: 10),
          Expanded(child: Text(label)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: myCustomAppBar(context, mart.name),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.blue.shade50,
                        child: Text(
                          mart.name.isNotEmpty ? mart.name[0].toUpperCase() : '?',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          mart.name,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if ((mart.description ?? '').isNotEmpty)
                    _infoRow(Icons.description, mart.description!),
                  if ((mart.address ?? '').isNotEmpty) _infoRow(Icons.location_on, mart.address!),
                  if ((mart.contactEmail ?? '').isNotEmpty)
                    _infoRow(Icons.email, mart.contactEmail!),
                  if ((mart.contactPhone ?? '').isNotEmpty)
                    _infoRow(Icons.phone, mart.contactPhone!),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('Status: ', style: TextStyle(fontWeight: FontWeight.w600)),
                      Text(
                        mart.isActive == true ? 'Active' : 'Inactive',
                        style: TextStyle(color: mart.isActive == true ? Colors.green : Colors.red),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
