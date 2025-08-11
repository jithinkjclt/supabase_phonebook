import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_book_app/presentation/screens/auth_page/cubit/auth_cubit.dart';
import 'package:phone_book_app/presentation/screens/auth_page/login_page.dart';
import 'package:phone_book_app/presentation/widget/spacing_extensions.dart';

import '../../widget/customtextfield.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (_) => AuthCubit(),
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            final cubit = context.read<AuthCubit>();
            return SingleChildScrollView(
              child: Center(
                child: Container(
                  color: Colors.white,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Form(
                    key: cubit.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      // Centered the content
                      children: [
                        const SizedBox(height: 100),
                        // Added spacing for the top
                        Row(
                          children: [
                            const Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF131145),
                              ),
                            ),
                          ],
                        ),
                        70.hBox,
                        // Use the provided CustomTextField for User Name
                        CustomTextField(
                          boxname: 'User Name',
                          hintText: 'Enter your user name',
                          controller: cubit.emailController,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 20),
                        // Use the provided CustomTextField for Password with the visibility toggle
                        CustomTextField(
                          boxname: 'Password',
                          hintText: 'Enter your password',
                          controller: cubit.passwordController,
                          obscureText: true,
                          trailingIconColor: Colors.deepPurple,
                        ),
                        const SizedBox(height: 20),
                        // Added field to confirm password
                        CustomTextField(
                          boxname: 'Confirm Password',
                          hintText: 'Re-enter your password',
                          controller: cubit.confirmPasswordController,
                          obscureText: true,
                          trailingIconColor: Colors.deepPurple,
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () async {
                              bool success = await cubit.signUp();
                              if (success) {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => const LoginPage(),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Sign up failed. Please try again.',
                                    ),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF131145),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already have an account?",
                              style: TextStyle(color: Colors.black54),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => const LoginPage(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Sign In',
                                style: TextStyle(
                                  color: Colors.deepPurple,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
