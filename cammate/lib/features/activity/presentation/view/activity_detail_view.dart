import 'package:cammate/core/common/appbar/my_custom_appbar.dart';
import 'package:cammate/features/activity/data/model/activity_model.dart';
import 'package:cammate/features/activity/presentation/view_model/activity_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActivityDetailView extends ConsumerWidget {
  final ActivityAPIModel activity;
  const ActivityDetailView({super.key, required this.activity});

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
      appBar: myCustomAppBar(context, activity.activityType),
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
                          activity.activityType.isNotEmpty
                              ? activity.activityType[0].toUpperCase()
                              : '?',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          activity.activityType,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          // open edit dialog for editable activity fields
                          await showDialog<bool>(
                            context: context,
                            builder: (ctx) {
                              final descriptionController = TextEditingController(
                                text: activity.description ?? '',
                              );
                              final statusController = TextEditingController(
                                text: activity.status ?? '',
                              );
                              final assignedController = TextEditingController(
                                text: activity.assignedTo ?? '',
                              );
                              final priorityController = TextEditingController(
                                text: activity.priority ?? '',
                              );

                              return StatefulBuilder(
                                builder: (ctx2, setState2) {
                                  return AlertDialog(
                                    title: const Text('Edit Activity'),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          TextField(
                                            controller: descriptionController,
                                            decoration: const InputDecoration(
                                              labelText: 'Description',
                                            ),
                                            maxLines: 3,
                                          ),
                                          const SizedBox(height: 8),
                                          TextField(
                                            controller: statusController,
                                            decoration: const InputDecoration(labelText: 'Status'),
                                          ),
                                          const SizedBox(height: 8),
                                          TextField(
                                            controller: assignedController,
                                            decoration: const InputDecoration(
                                              labelText: 'Assigned To',
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          TextField(
                                            controller: priorityController,
                                            decoration: const InputDecoration(
                                              labelText: 'Priority',
                                            ),
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
                                          final success = await ref
                                              .read(activityViewModelProvider.notifier)
                                              .updateActivity(
                                                activity.id!,
                                                description:
                                                    descriptionController.text.trim().isEmpty
                                                        ? null
                                                        : descriptionController.text.trim(),
                                                status:
                                                    statusController.text.trim().isEmpty
                                                        ? null
                                                        : statusController.text.trim(),
                                                assignedTo:
                                                    assignedController.text.trim().isEmpty
                                                        ? null
                                                        : assignedController.text.trim(),
                                                priority:
                                                    priorityController.text.trim().isEmpty
                                                        ? null
                                                        : priorityController.text.trim(),
                                                context: context,
                                              );
                                          if (success) {
                                            Navigator.pop(ctx2, true);
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
                    ],
                  ),
                  const SizedBox(height: 12),
                  _infoRow(Icons.description, activity.description ?? ''),
                  _infoRow(Icons.category, activity.activityType),
                  if (activity.imageUrl != null) _infoRow(Icons.image, activity.imageUrl!),
                  if (activity.videoClip != null) _infoRow(Icons.videocam, activity.videoClip!),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('Status: ', style: TextStyle(fontWeight: FontWeight.w600)),
                      Text(
                        activity.status ?? 'Unknown',
                        style: TextStyle(
                          color: activity.status == 'open' ? Colors.green : Colors.red,
                        ),
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
