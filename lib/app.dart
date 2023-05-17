import 'package:flutter/material.dart';
import 'package:flutter_name_card_printer/feature/common/theme/theme.dart';
import 'package:flutter_name_card_printer/feature/home/screen/home_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      home: const HomeScreen(),
    );
  }
}
