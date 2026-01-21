import 'package:cammate/core/common/appbar/my_custom_appbar.dart';
import 'package:cammate/features/user/data/model/user_model.dart';
import 'package:cammate/features/user/presentation/view_model/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserDetailView extends ConsumerWidget {
  final UserAPIModel user;
  const UserDetailView({super.key, required this.user});

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
    final isSuperUser = user.role.toLowerCase() == 'superuser';
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: myCustomAppBar(context, '${user.firstName} ${user.lastName}'),
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
                          ('${user.firstName} ${user.lastName}').trim().isNotEmpty
                              ? ('${user.firstName} ${user.lastName}').trim()[0].toUpperCase()
                              : '?',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '${user.firstName} ${user.lastName}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                      ),
                      // Only show edit action for non-superusers.
                      if (!isSuperUser)
                        Tooltip(
                          message: 'Edit user',
                          child: IconButton(
                            onPressed: () async {
                              // open edit dialog
                              await showDialog<bool>(
                                context: context,
                                builder: (ctx) {
                                  final emailController = TextEditingController(text: user.email);
                                  final firstController = TextEditingController(
                                    text: user.firstName,
                                  );
                                  final lastController = TextEditingController(text: user.lastName);
                                  final roleController = TextEditingController(text: user.role);
                                  final martController = TextEditingController(
                                    text: user.martId?.toString() ?? '',
                                  );
                                  bool isActive = user.isActive ?? true;

                                  return StatefulBuilder(
                                    builder: (ctx2, setState2) {
                                      final formKey = GlobalKey<FormState>();
                                      bool isSubmitting = false;
                                      return AlertDialog(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                                        actionsPadding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        title: const Text('Edit User'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const SizedBox(height: 4),
                                            Form(
                                              key: formKey,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  TextFormField(
                                                    controller: emailController,
                                                    decoration: InputDecoration(
                                                      labelText: 'Email',
                                                      filled: true,
                                                      fillColor: Colors.grey.shade100,
                                                      contentPadding: const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 12,
                                                      ),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(30),
                                                        borderSide: BorderSide.none,
                                                      ),
                                                    ),
                                                    validator:
                                                        (v) =>
                                                            (v == null || v.trim().isEmpty)
                                                                ? 'Email required'
                                                                : null,
                                                    textInputAction: TextInputAction.next,
                                                  ),
                                                  const SizedBox(height: 12),
                                                  TextFormField(
                                                    controller: firstController,
                                                    decoration: InputDecoration(
                                                      labelText: 'First name',
                                                      filled: true,
                                                      fillColor: Colors.grey.shade100,
                                                      contentPadding: const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 12,
                                                      ),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(30),
                                                        borderSide: BorderSide.none,
                                                      ),
                                                    ),
                                                    textInputAction: TextInputAction.next,
                                                  ),
                                                  const SizedBox(height: 12),
                                                  TextFormField(
                                                    controller: lastController,
                                                    decoration: InputDecoration(
                                                      labelText: 'Last name',
                                                      filled: true,
                                                      fillColor: Colors.grey.shade100,
                                                      contentPadding: const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 12,
                                                      ),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(30),
                                                        borderSide: BorderSide.none,
                                                      ),
                                                    ),
                                                    textInputAction: TextInputAction.next,
                                                  ),
                                                  const SizedBox(height: 12),
                                                  TextFormField(
                                                    controller: roleController,
                                                    decoration: InputDecoration(
                                                      labelText: 'Role',
                                                      filled: true,
                                                      fillColor: Colors.grey.shade100,
                                                      contentPadding: const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 12,
                                                      ),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(30),
                                                        borderSide: BorderSide.none,
                                                      ),
                                                    ),
                                                    textInputAction: TextInputAction.next,
                                                  ),
                                                  const SizedBox(height: 12),
                                                  TextFormField(
                                                    controller: martController,
                                                    decoration: InputDecoration(
                                                      labelText: 'Mart ID (optional)',
                                                      filled: true,
                                                      fillColor: Colors.grey.shade100,
                                                      contentPadding: const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 12,
                                                      ),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(30),
                                                        borderSide: BorderSide.none,
                                                      ),
                                                    ),
                                                    keyboardType: TextInputType.number,
                                                    textInputAction: TextInputAction.done,
                                                  ),
                                                  const SizedBox(height: 12),
                                                  Row(
                                                    children: [
                                                      Checkbox(
                                                        value: isActive,
                                                        onChanged:
                                                            (v) => setState2(
                                                              () => isActive = v ?? true,
                                                            ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      const Text('Active'),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed:
                                                isSubmitting
                                                    ? null
                                                    : () => Navigator.pop(ctx2, false),
                                            child: const Text('Cancel'),
                                          ),
                                          ElevatedButton(
                                            onPressed:
                                                isSubmitting
                                                    ? null
                                                    : () async {
                                                      final valid =
                                                          formKey.currentState?.validate() ?? false;
                                                      if (!valid) return;
                                                      setState2(() => isSubmitting = true);
                                                      final updated = UserAPIModel(
                                                        id: user.id,
                                                        email: emailController.text.trim(),
                                                        firstName: firstController.text.trim(),
                                                        lastName: lastController.text.trim(),
                                                        role: roleController.text.trim(),
                                                        isActive: isActive,
                                                        martId:
                                                            martController.text.trim().isEmpty
                                                                ? null
                                                                : int.tryParse(
                                                                  martController.text.trim(),
                                                                ),
                                                        createdById: user.createdById,
                                                        createdAt: user.createdAt,
                                                        updatedAt: DateTime.now(),
                                                      );

                                                      final success = await ref
                                                          .read(userViewModelProvider.notifier)
                                                          .updateUser(user.id!, updated, context);
                                                      if (success) {
                                                        Navigator.pop(ctx2, true);
                                                        Navigator.pop(context);
                                                      }
                                                      setState2(() => isSubmitting = false);
                                                    },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(0xFF0B5FFF),
                                              foregroundColor: Colors.white,
                                              shape: const StadiumBorder(),
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 18,
                                                vertical: 12,
                                              ),
                                            ),
                                            child:
                                                isSubmitting
                                                    ? const SizedBox(
                                                      width: 20,
                                                      height: 20,
                                                      child: CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                    : const Text('Save'),
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
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _infoRow(Icons.email, user.email),
                  _infoRow(Icons.person, user.role),
                  if (user.martId != null) _infoRow(Icons.store, 'Mart ID: ${user.martId}'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('Status: ', style: TextStyle(fontWeight: FontWeight.w600)),
                      Text(
                        user.isActive == true ? 'Active' : 'Inactive',
                        style: TextStyle(color: user.isActive == true ? Colors.green : Colors.red),
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
