import 'package:cammate/core/common/appbar/my_custom_appbar.dart';
import 'package:cammate/core/shared_pref/user_shared_prefs.dart';
import 'package:cammate/features/auth/presentation/view_model/auth_view_model.dart';
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
  String role = "";

  @override
  void initState() {
    super.initState();
    getUser();
    _loadRole();
  }

  void _confirmLogout(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder:
          (dialogCtx) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: const Text('Confirm Logout'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 4),
                Icon(Icons.logout, size: 48, color: Colors.redAccent),
                const SizedBox(height: 12),
                const Text('You will be signed out of this device. Continue?'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogCtx).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(dialogCtx).pop();
                  ref.read(authViewModelProvider.notifier).logout(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                ),
                child: const Text('Logout'),
              ),
            ],
          ),
    );
  }

  Future<void> _loadRole() async {
    final res = await userSharedPrefs.getUserRole();
    res.fold((_) => setState(() => role = ''), (r) => setState(() => role = r ?? ''));
  }

  Future<void> getUser() async {
    final res = await userSharedPrefs.getUser();
    if (res != null) {
      setState(() {
        user = res;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayName = user != null ? (user!['full_name'] ?? user!['username'] ?? 'User') : 'User';

    return Scaffold(
      appBar: myCustomAppBar(context, 'Profile'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.indigo,
                child: Text(
                  displayName.isNotEmpty ? displayName[0].toUpperCase() : 'U',
                  style: const TextStyle(fontSize: 32, color: Colors.white),
                ),
              ),
              const SizedBox(height: 12),
              Text(displayName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              if (role.trim().isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _roleColor(role).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _roleColor(role).withOpacity(0.2)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.person, size: 16, color: _roleColor(role)),
                      const SizedBox(width: 8),
                      Text(
                        _formatRole(role),
                        style: TextStyle(
                          color: _roleColor(role),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showChangePasswordDialog(context),
                  icon: const Icon(Icons.lock, color: Colors.white),
                  label: const Text(
                    'Change Password',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _confirmLogout(context),
                  icon: const Icon(Icons.logout, color: Colors.red),
                  label: const Text('Logout', style: TextStyle(fontSize: 16, color: Colors.red)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.redAccent),
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext parentContext) {
    final currentController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog<void>(
      context: parentContext,
      barrierDismissible: false,
      builder: (dialogContext) {
        // local state
        bool obscureCurrent = true;
        bool obscureNew = true;
        bool obscureConfirm = true;
        bool isSubmitting = false;

        String? validateCurrent(String? v) =>
            (v == null || v.trim().isEmpty) ? 'Current password required' : null;
        String? validateNew(String? v) {
          if (v == null || v.trim().isEmpty) return 'New password required';
          if (v.trim().length < 8) return 'Use at least 8 characters';
          return null;
        }

        String? validateConfirm(String? v) {
          if (v == null || v.trim().isEmpty) return 'Please confirm new password';
          if (v.trim() != newController.text.trim()) return 'Passwords do not match';
          return null;
        }

        return StatefulBuilder(
          builder:
              (context, setState) => AlertDialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                title: const Text('Change Password'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Provide your current password and choose a new one.'),
                    const SizedBox(height: 12),
                    Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: currentController,
                            obscureText: obscureCurrent,
                            decoration: InputDecoration(
                              labelText: 'Current password',
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
                              suffixIcon: IconButton(
                                icon: Icon(
                                  obscureCurrent ? Icons.visibility_off : Icons.visibility,
                                ),
                                onPressed: () => setState(() => obscureCurrent = !obscureCurrent),
                              ),
                            ),
                            validator: validateCurrent,
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: newController,
                            obscureText: obscureNew,
                            decoration: InputDecoration(
                              labelText: 'New password',
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
                              suffixIcon: IconButton(
                                icon: Icon(obscureNew ? Icons.visibility_off : Icons.visibility),
                                onPressed: () => setState(() => obscureNew = !obscureNew),
                              ),
                            ),
                            validator: validateNew,
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: confirmController,
                            obscureText: obscureConfirm,
                            decoration: InputDecoration(
                              labelText: 'Confirm new password',
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
                              suffixIcon: IconButton(
                                icon: Icon(
                                  obscureConfirm ? Icons.visibility_off : Icons.visibility,
                                ),
                                onPressed: () => setState(() => obscureConfirm = !obscureConfirm),
                              ),
                            ),
                            validator: validateConfirm,
                            textInputAction: TextInputAction.done,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: isSubmitting ? null : () => Navigator.of(dialogContext).pop(),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed:
                        isSubmitting
                            ? null
                            : () async {
                              final valid = formKey.currentState?.validate() ?? false;
                              if (!valid) return;
                              setState(() => isSubmitting = true);
                              await ref
                                  .read(authViewModelProvider.notifier)
                                  .changePassword(
                                    currentController.text.trim(),
                                    newController.text.trim(),
                                    dialogContext,
                                  );
                              if (mounted) setState(() => isSubmitting = false);
                            },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0B5FFF),
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    ),
                    child:
                        isSubmitting
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                            : const Text('Change'),
                  ),
                ],
              ),
        );
      },
    );
  }

  Color _roleColor(String r) {
    final key = r.toLowerCase();
    if (key.contains('admin') || key.contains('super')) return Colors.indigo;
    if (key.contains('staff')) return Colors.green;
    if (key.contains('seller') || key.contains('vendor')) return Colors.orange;
    return Colors.grey.shade600;
  }

  String _formatRole(String r) {
    if (r.trim().isEmpty) return '';
    final parts = r.split(RegExp(r"[ _-]+"));
    return parts
        .map((p) => p.isEmpty ? p : '${p[0].toUpperCase()}${p.substring(1).toLowerCase()}')
        .join(' ');
  }
}
