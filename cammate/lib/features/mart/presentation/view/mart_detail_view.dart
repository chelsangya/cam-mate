import 'package:cammate/core/common/appbar/my_custom_appbar.dart';
import 'package:cammate/features/mart/data/model/mart_model.dart';
import 'package:cammate/features/mart/presentation/view_model/mart_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MartDetailView extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
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
                      IconButton(
                        onPressed: () async {
                          // open edit dialog
                          await showDialog<bool>(
                            context: context,
                            builder: (ctx) {
                              final nameController = TextEditingController(text: mart.name);
                              final descController = TextEditingController(text: mart.description);
                              final addressController = TextEditingController(text: mart.address);
                              final emailController = TextEditingController(
                                text: mart.contactEmail,
                              );
                              final phoneController = TextEditingController(
                                text: mart.contactPhone,
                              );
                              bool isActive = mart.isActive ?? true;

                              return StatefulBuilder(
                                builder: (ctx2, setState2) {
                                  return AlertDialog(
                                    title: const Text('Edit Mart'),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          TextField(
                                            controller: nameController,
                                            decoration: const InputDecoration(labelText: 'Name'),
                                          ),
                                          const SizedBox(height: 8),
                                          TextField(
                                            controller: descController,
                                            decoration: const InputDecoration(
                                              labelText: 'Description',
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          TextField(
                                            controller: addressController,
                                            decoration: const InputDecoration(labelText: 'Address'),
                                          ),
                                          const SizedBox(height: 8),
                                          TextField(
                                            controller: emailController,
                                            decoration: const InputDecoration(
                                              labelText: 'Contact Email',
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          TextField(
                                            controller: phoneController,
                                            decoration: const InputDecoration(
                                              labelText: 'Contact Phone',
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Checkbox(
                                                value: isActive,
                                                onChanged:
                                                    (v) => setState2(() => isActive = v ?? true),
                                              ),
                                              const SizedBox(width: 8),
                                              const Text('Active'),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(ctx2, false),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          final updated = MartAPIModel(
                                            id: mart.id,
                                            name: nameController.text.trim(),
                                            description:
                                                descController.text.trim().isEmpty
                                                    ? null
                                                    : descController.text.trim(),
                                            address:
                                                addressController.text.trim().isEmpty
                                                    ? null
                                                    : addressController.text.trim(),
                                            contactEmail:
                                                emailController.text.trim().isEmpty
                                                    ? null
                                                    : emailController.text.trim(),
                                            contactPhone:
                                                phoneController.text.trim().isEmpty
                                                    ? null
                                                    : phoneController.text.trim(),
                                            isActive: isActive,
                                          );

                                          final success = await ref
                                              .read(martViewModelProvider.notifier)
                                              .updateMart(mart.id!, updated, context);
                                          if (success) {
                                            Navigator.pop(ctx2, true);
                                            // close detail view so list will reflect changes (the viewmodel triggers a refresh)
                                            Navigator.pop(context);
                                          }
                                        },
                                        child: const Text('Save'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.edit, color: Colors.blue),
                      ),
                      IconButton(
                        onPressed: () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            barrierDismissible: false,
                            builder: (ctx) => AlertDialog(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                              actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              title: const Text('Delete mart'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 4),
                                  Icon(Icons.delete_forever, size: 48, color: Colors.redAccent),
                                  const SizedBox(height: 12),
                                  Text('Delete "${mart.name}"? This action cannot be undone.'),
                                ],
                              ),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(ctx, true),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    foregroundColor: Colors.white,
                                    shape: const StadiumBorder(),
                                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                                  ),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );

                          if (confirmed != true) return;
                          // perform delete and pop back if successful
                          final success = await ref
                              .read(martViewModelProvider.notifier)
                              .deleteMart(mart.id!, context);
                          if (success) Navigator.pop(context);
                        },
                        icon: const Icon(Icons.delete, color: Colors.red),
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
