import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  bool _rememberMe = false;
  bool _passwordVisible = false;
  final emailController = TextEditingController();
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
    } else if (value.length < 8) {
      return 'Password cannot be less than 8 characters';
    } else if (value.length > 15) {
      return 'Password cannot be more than 15 characters';
    }
    return null;
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
                        controller: emailController,
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
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Colors.black,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Checkbox(
                                side: const BorderSide(color: Colors.black),
                                checkColor: Colors.white,
                                value: _rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    _rememberMe = value!;
                                  });
                                },
                              ),
                              const Text(
                                'Remember me',
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Forgot password?',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 400,
                        child: ElevatedButton(
                          onPressed: () {
                            // login(context);
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   const SnackBar(
                            //     content: Text('Logging in...'),
                            //     backgroundColor: Colors.green,
                            //   ),
                            // );
                            // Navigator.of(context).pushNamed('/home');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF444444),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
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

                      //   onPressed: () {},
                      //   icon: const Icon(Icons.face),
                      //   label: const Text('Sign in with Face ID'),
                      //   style: ElevatedButton.styleFrom(
                      //     shadowColor: const Color(0xFF0B2B3D),
                      //     side: const BorderSide(color: Color(0xFF0B2B3D)),
                      //     foregroundColor: Colors.black,
                      //     backgroundColor: Colors.white,
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(30),
                      //     ),
                      //   ),
                      // ),
                      // const SizedBox(width: 10),
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
