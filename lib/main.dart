import 'package:flutter/material.dart';
import 'theme/zen_theme.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const DeciderApp());
}

class DeciderApp extends StatelessWidget {
  const DeciderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Decider',
      debugShowCheckedModeBanner: false,
      theme: ZenTheme.theme,
      home: const HomeScreen(),
    );
  }
}
