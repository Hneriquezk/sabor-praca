import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_config.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);

  runApp(const SaborEPracaApp());
}

class SaborEPracaApp extends StatelessWidget {
  const SaborEPracaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sabor & Praça',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFD2451E),
        scaffoldBackgroundColor: const Color(0xFFF5E6C8),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
