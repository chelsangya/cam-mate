// ignore_for_file: use_build_context_synchronously

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

  void _togglePasswordVisibility() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email address';
    }
    String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    } else if (value.length < 3) {
      return 'Password cannot be less than 3 characters';
    } else if (value.length > 15) {
      return 'Password cannot be more than 15 characters';
    }
    return null;
  }

  void forgotPassword(BuildContext context) {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Reset Password'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Enter your email to receive password reset instructions.'),
                const SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email', hintText: 'user@gmail.com'),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
              TextButton(
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
                        val['message'] ?? 'If the email exists, a reset link has been sent.';
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.green));
                    Future.delayed(const Duration(milliseconds: 300), () {
                      _showResetWithTokenDialog(context);
                    });
                  }
                },
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

    final passwordError = validatePassword(password);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(username), backgroundColor: Colors.red));

    if (passwordError != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(passwordError), backgroundColor: Colors.red));
      return;
    }

    ref.read(authViewModelProvider.notifier).loginUser(context, username, password);
    // Navigator.of(context).pushNamed('/');
  }

  /// Show dialog where user enters the token from email and the new password.
  void _showResetWithTokenDialog(BuildContext context) {
    final tokenController = TextEditingController();
    final newPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Complete Password Reset'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Enter the token sent to your email and choose a new password.'),
                const SizedBox(height: 12),
                TextField(
                  controller: tokenController,
                  decoration: const InputDecoration(
                    labelText: 'Token',
                    hintText: 'paste token here',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'New password',
                    hintText: 'New password',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
              TextButton(
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

                  // Call ViewModel to complete reset. The ViewModel handles SnackBars/navigation.
                  await ref
                      .read(authViewModelProvider.notifier)
                      .resetPasswordWithToken(token, newPassword, context);
                },
                child: const Text('Reset'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final authState = ref.watch(authViewModelProvider);

    return Scaffold(
      // fffbff
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 320,
                      height: 150,
                      color: Colors.black54,
                    ),
                  ),
                  const Text(
                    'Welcome Back!',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Login to your account',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          hintText: 'johndoe@gmail.com',
                          hintStyle: TextStyle(color: Colors.grey),
                          labelStyle: TextStyle(color: Colors.black),
                          prefixIcon: Icon(Icons.mail, color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: '********',
                          hintStyle: const TextStyle(color: Colors.grey),
                          labelStyle: const TextStyle(color: Colors.black),
                          prefixIcon: const Icon(Icons.lock, color: Colors.black),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible ? Icons.visibility : Icons.visibility_off,
                              color: Colors.black,
                            ),
                            onPressed: _togglePasswordVisibility,
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                        obscureText: !_passwordVisible,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () => forgotPassword(context),
                            child: const Text(
                              'Forgot Password',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: 400,
                        child: ElevatedButton(
                          onPressed: () {
                            login(context);
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   const SnackBar(
                            //     content: Text('Logging in...'),
                            //     backgroundColor: Colors.green,
                            //   ),
                            // );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF444444),
                            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          child: const Text(
                            'LOGIN',
                            style: TextStyle(
                              color: Color(0xFFFFFBFF),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // add reset password link
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
