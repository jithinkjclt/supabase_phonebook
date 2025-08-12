import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:phone_book_app/data/constants/api.dart';
import 'package:phone_book_app/presentation/screens/auth_page/login_page.dart';
import 'package:phone_book_app/presentation/screens/contact_page/contact_page.dart';


import 'core/themes/AppThemes.dart';
import 'core/themes/theme_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Load environment variables
  await dotenv.load(fileName: "api_key.env");
  String apiToken = dotenv.env['API_TOKEN'] ?? '';

  // Initialize Supabase
  await Supabase.initialize(url: url, anonKey: apiToken);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'Phone Book App',
            debugShowCheckedModeBanner: false,
            // Apply themes based on the current themeMode state
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            themeMode: themeMode,
            home: const ContactPage(),
          );
        },
      ),
    );
  }
}