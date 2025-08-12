import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:phone_book_app/data/constants/token.dart';
import 'package:phone_book_app/presentation/screens/auth_page/login_page.dart';
import 'package:phone_book_app/presentation/screens/contact_page/contact_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'data/constants/api.dart';

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
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // The .env file must be loaded before you can access its contents.
  await dotenv.load(fileName: "api_key.env");

  // Now you can safely access the environment variable.
  String apiToken = dotenv.env['API_TOKEN'] ?? '';

  await Supabase.initialize(url: url, anonKey: apiToken);
  runApp(const MyApp());
}
