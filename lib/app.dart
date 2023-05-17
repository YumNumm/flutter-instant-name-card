import 'package:flutter/material.dart';
import 'package:flutter_name_card_printer/feature/common/router/router_provider.dart';
import 'package:flutter_name_card_printer/feature/common/theme/theme.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    return MaterialApp.router(
      theme: lightTheme,
      darkTheme: darkTheme,
      title: 'InstrantNameCardApp',
      routerConfig: router,
    );
  }
}
