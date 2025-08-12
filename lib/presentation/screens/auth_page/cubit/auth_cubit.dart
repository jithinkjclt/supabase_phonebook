import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../data/constants/token.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  // Initialize Supabase client
  final SupabaseClient _supabase = Supabase.instance.client;

  AuthCubit() : super(AuthInitial());

  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Future<bool> signUp() async {
    print('signUp() called');

    if (!formKey.currentState!.validate()) {
      print('Form validation failed');
      return false;
    }
    print('Form validated successfully');

    emit(AuthLoading());
    print('AuthLoading state emitted');

    try {
      print('Calling Supabase signUp with email: ${emailController.text}');

      final AuthResponse res = await _supabase.auth.signUp(
        email: emailController.text,
        password: passwordController.text,
      );

      print('Supabase signUp response received');
      print('User: ${res.user}');
      print('Session: ${res.session}');

      if (res.user != null) {
        print('User is not null, emitting AuthAuthenticated');
        emit(AuthAuthenticated(user: res.user!));
        return true; // Success
      } else {
        print('User is null, emitting AuthError');
        emit(AuthError(message: 'Sign up failed. Please check your details.'));
        return false; // Failure
      }
    } on AuthException catch (e) {
      print('Caught AuthException: ${e.message}');
      emit(AuthError(message: e.message));
      return false; // Failure
    } catch (e) {
      print('Caught unknown exception: $e');
      emit(AuthError(message: 'An unknown error occurred.'));
      return false; // Failure
    }
  }

  Future<bool> signIn() async {
    if (!formKey.currentState!.validate()) return false;
    emit(AuthLoading());
    try {
      final AuthResponse res = await _supabase.auth.signInWithPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      if (res.user != null) {
        userToken = res.session?.accessToken;
        emit(AuthAuthenticated(user: res.user!));
        return true;
      } else {
        emit(
          AuthError(message: 'Sign in failed. Please check your credentials.'),
        );
        return false;
      }
    } on AuthException catch (e) {
      emit(AuthError(message: e.message));
      return false;
    } catch (e) {
      emit(AuthError(message: 'An unknown error occurred.'));
      return false;
    }
  }
}
