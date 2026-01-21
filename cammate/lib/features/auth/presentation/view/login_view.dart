// ignore_for_file: use_build_context_synchronously

import 'package:cammate/features/auth/presentation/state/auth_state.dart';
import 'package:cammate/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  bool _passwordVisible = false;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _togglePasswordVisibility() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  // Note: we must not call `ref.listen` in initState for ConsumerStatefulWidget
  // because Riverpod requires `ref.listen` to be used inside build for
  // Consumer widgets. The listener is added inside `build` below.

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Please enter an email address';
    final v = value.trim();
    // simple, permissive email regex: local@domain.tld (allows dots, dashes, underscores)
    const pattern = r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$';
    final regExp = RegExp(pattern);
    if (!regExp.hasMatch(v)) return 'Please enter a valid email address';
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter a password';
    if (value.length < 8) return 'Password must be at least 8 characters';
    final hasUpper = RegExp(r'[A-Z]').hasMatch(value);
    final hasSpecial = RegExp(r'[!@#\$%\^&\*\(\)_\+\-=\[\]{};:\\\|,.<>\/?~`]').hasMatch(value);
    if (!hasUpper) return 'Password must contain at least one uppercase letter';
    if (!hasSpecial) return 'Password must contain at least one special character';
    return null;
  }

  void _showResetWithTokenDialog(BuildContext context) {
    final tokenController = TextEditingController();
    final newPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: const Text('Complete Password Reset'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Enter the token sent to your email and choose a new password.'),
                const SizedBox(height: 12),
                TextField(
                  controller: tokenController,
                  decoration: InputDecoration(
                    labelText: 'Token',
                    hintText: 'paste token here',
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'New password',
                    hintText: 'New password',
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () async {
                  final token = tokenController.text.trim();
                  final newPassword = newPasswordController.text;

                  if (token.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter the token'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  final passwordError = validatePassword(newPassword);
                  if (passwordError != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(passwordError), backgroundColor: Colors.red),
                    );
                    return;
                  }

                  Navigator.of(ctx).pop();

                  final val = await ref
                      .read(authViewModelProvider.notifier)
                      .resetPasswordWithToken(token, newPassword, context);
                  
                
                  // if (val != null && val['message'] == msg) {

                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     SnackBar(content: Text(msg), backgroundColor: Colors.green),
                  //   );
                  // } else {
                  //   final msg = val?['message']?.toString() ?? 'Failed to reset password';
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     SnackBar(content: Text(msg), backgroundColor: Colors.red),
                  //   );

                  // }
                  // )
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0B5FFF),
                  foregroundColor: Colors.white,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                ),
                child: const Text('Reset'),
              ),
            ],
          ),
    );
  }

  void forgotPassword(BuildContext context) {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: const Text('Reset Password'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Enter your email to receive password reset instructions.'),
                const SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'user@gmail.com',
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () async {
                  final email = emailController.text.trim();
                  final emailError = validateEmail(email);
                  if (emailError != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(emailError), backgroundColor: Colors.red),
                    );
                    return;
                  }

                  Navigator.of(ctx).pop();

                  final val = await ref
                      .read(authViewModelProvider.notifier)
                      .forgotPassword(email, context);
                  if (val != null && val['success'] == true) {
                    final msg =
                        val['message']?.toString() ??
                        'If the email exists, a reset link has been sent.';
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.green));

                    _showResetWithTokenDialog(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0B5FFF),
                  foregroundColor: Colors.white,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                ),
                child: const Text('Send'),
              ),
            ],
          ),
    );
  }

  // Login function
  void login(BuildContext context) {
    final username = usernameController.text;
    final password = passwordController.text;

    ref.read(authViewModelProvider.notifier).loginUser(context, username, password);
  }

  @override
  Widget build(BuildContext context) {
    // Watch state and also install a listener here (legal with Riverpod).
    final authState = ref.watch(authViewModelProvider);
    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      final showPrev = previous?.showMessage ?? false;
      final showNow = next.showMessage;
      if (!showPrev && showNow) {
        final text = next.error ?? next.message ?? '';
        if (text.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            final isCurrent = ModalRoute.of(context)?.isCurrent ?? false;
            if (!isCurrent) {
              ref.read(authViewModelProvider.notifier).resetMessage(false);
              return;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(text),
                backgroundColor: next.error != null ? Colors.red : Colors.green,
              ),
            );
            ref.read(authViewModelProvider.notifier).resetMessage(false);
          }
          );
        }
      }
    }
    );

    return Scaffold(
      body: Container(
        color: const Color(0xFFF5F7FA),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 28.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // original app logo (tinted black for better visibility on light background)
                  Image.asset(
                    'assets/images/logo.png',
                    width: 120,
                    height: 60,
                    fit: BoxFit.contain,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 18),

                  // form container (rounded, airy)
                  Container(
                    constraints: const BoxConstraints(maxWidth: 420),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, 8)),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Welcome Back',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Sign in to continue',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 13, color: Colors.black54),
                          ),
                          const SizedBox(height: 14),

                          TextFormField(
                            controller: usernameController,
                            keyboardType: TextInputType.emailAddress,
                            validator: validateEmail,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: const Icon(Icons.mail, color: Color(0xFF0B5FFF)),
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          TextFormField(
                            controller: passwordController,
                            obscureText: !_passwordVisible,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: const Icon(Icons.lock, color: Color(0xFF0B5FFF)),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                                  color: Colors.black54,
                                ),
                                onPressed: _togglePasswordVisibility,
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => forgotPassword(context),
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: Color(0xFF0B5FFF),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 6),

                          SizedBox(
                            height: 52,
                            child: ElevatedButton(
                              onPressed:
                                  authState.isLoading
                                      ? null
                                      : () {
                                        if (_formKey.currentState?.validate() ?? false) {
                                          login(context);
                                        }
                                      },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0B5FFF),
                                foregroundColor: Colors.white,
                                disabledBackgroundColor: Color(0xFF8FB1FF),
                                disabledForegroundColor: Colors.white70,
                                shape: const StadiumBorder(),
                                elevation: 4,
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              child:
                                  authState.isLoading
                                      ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                      : const Text('Log in'),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const SizedBox.shrink(),
                        ],
                      ),
                    ),
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
