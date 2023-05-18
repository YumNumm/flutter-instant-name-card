import 'package:flutter/material.dart';
import 'package:flutter_name_card_printer/app.dart';
import 'package:flutter_name_card_printer/feature/common/provider/shared_preferences.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SunmiPrinter.bindingPrinter();

  final prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const App(),
    ),
  );
}
