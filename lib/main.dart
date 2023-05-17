import 'package:flutter/material.dart';
import 'package:flutter_name_card_printer/app.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> main() async {
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
