import 'package:flutter/material.dart';
import 'package:phone_book_app/data/token.dart';
import 'package:phone_book_app/presentation/screens/auth_page/login_page.dart';

import 'package:phone_book_app/presentation/screens/contact_page/contact_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phone Book App',
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(url: url, anonKey: token);
  runApp(const MyApp());
}
