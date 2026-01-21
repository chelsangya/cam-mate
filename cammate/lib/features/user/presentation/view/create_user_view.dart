import 'package:cammate/core/common/appbar/my_custom_appbar.dart';
import 'package:cammate/features/mart/presentation/view_model/mart_view_model.dart';
import 'package:cammate/features/user/data/model/user_model.dart';
import 'package:cammate/features/user/presentation/view_model/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateUserView extends ConsumerStatefulWidget {
  const CreateUserView({super.key});

  @override
  ConsumerState<CreateUserView> createState() => _CreateUserViewState();
}

class _CreateUserViewState extends ConsumerState<CreateUserView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String? _selectedRole;
  int? _selectedMartId;
  final TextEditingController _passwordController = TextEditingController();
  bool _isActive = true;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // fetch marts for the mart dropdown
    Future.microtask(() => ref.read(martViewModelProvider.notifier).fetchAllMarts(context));
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final user = UserAPIModel(
      id: null,
      email: _emailController.text.trim(),
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      role: (_selectedRole ?? 'viewer'),
      isActive: _isActive,
      martId: (_selectedRole == 'superuser') ? null : _selectedMartId,
    );

    // NOTE: backend create may require password; UserAPIModel.toBody supports password but
    // the viewmodel currently accepts only UserAPIModel. If your backend expects a password,
    // we'll need to pass it through to the datasource (follow-up change). For now we build
    // the UserAPIModel and call createUser.
    ref
        .read(userViewModelProvider.notifier)
        .createUser(user, context, password: _passwordController.text.trim());
  }

  InputDecoration _fieldDecoration(BuildContext context, String label) => InputDecoration(
    labelText: label,
    filled: true,
    // subtle contrast inside the white card
    fillColor: Colors.grey.shade50,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade200),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade200),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1.5),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userViewModelProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: myCustomAppBar(context, 'Create User'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _firstNameController,
                      decoration: _fieldDecoration(context, 'First name'),
                      validator:
                          (v) => (v == null || v.trim().isEmpty) ? 'First name is required' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _lastNameController,
                      decoration: _fieldDecoration(context, 'Last name'),
                      validator:
                          (v) => (v == null || v.trim().isEmpty) ? 'Last name is required' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _emailController,
                      decoration: _fieldDecoration(context, 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Email is required';
                        if (!RegExp(r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}").hasMatch(v.trim()))
                          return 'Enter a valid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedRole,
                      decoration: _fieldDecoration(context, 'Role'),
                      items:
                          ['SUPERUSER', 'ADMIN', 'MANAGER', 'VIEWER']
                              .map(
                                (r) => DropdownMenuItem(
                                  value: r,
                                  child: Text(r[0].toUpperCase() + r.substring(1)),
                                ),
                              )
                              .toList(),
                      onChanged: (v) => setState(() => _selectedRole = v),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Role is required' : null,
                    ),
                    const SizedBox(height: 12),
                    // Mart selection: hide/skip for superuser role
                    if ((_selectedRole ?? '').toLowerCase() != 'superuser')
                      Builder(
                        builder: (ctx) {
                          final martState = ref.watch(martViewModelProvider);
                          final marts = martState.marts;
                          return DropdownButtonFormField<int>(
                            initialValue: _selectedMartId,
                            decoration: _fieldDecoration(context, 'Mart'),
                            items:
                                marts
                                    .map(
                                      (m) =>
                                          DropdownMenuItem<int>(value: m.id, child: Text(m.name)),
                                    )
                                    .toList(),
                            onChanged: (v) => setState(() => _selectedMartId = v),
                            validator: (v) {
                              if ((_selectedRole ?? '').toLowerCase() == 'superuser') return null;
                              if (v == null) return 'Please select a mart';
                              return null;
                            },
                          );
                        },
                      )
                    else
                      const SizedBox.shrink(),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _passwordController,
                      decoration: _fieldDecoration(context, 'Password'),
                      obscureText: true,
                      validator: (v) {
                        final value = v?.trim() ?? '';
                        if (value.isEmpty) return 'Password is required';
                        if (value.length < 8) return 'Password must be at least 8 characters';
                        final hasUpper = RegExp(r'[A-Z]').hasMatch(value);
                        final hasSpecial = RegExp(
                          r'[!@#\$%\^&\*\(\)_\+\-=\[\]{};:\\\|,.<>\/?~`]',
                        ).hasMatch(value);
                        if (!hasUpper) return 'Password must contain at least one uppercase letter';
                        if (!hasSpecial)
                          return 'Password must contain at least one special character';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Checkbox(
                          value: _isActive,
                          onChanged: (v) => setState(() => _isActive = v ?? true),
                        ),
                        const SizedBox(width: 8),
                        const Text('Active'),
                      ],
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: state.isLoading ? null : _submit,
                        child:
                            state.isLoading
                                ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Text('Creating...'),
                                  ],
                                )
                                : const Text('Create User'),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
