import 'package:flutter/material.dart';
import 'package:flutter_name_card_printer/feature/home/viewmodel/home_screen_viewmodel.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('即席名刺'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed:
                ref.read(homeScreenViewModelProvider).navigateToSettingScreen,
          ),
        ],
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('名刺の内容を入力する'),
            leading: const Icon(Icons.input),
            onTap: ref.read(homeScreenViewModelProvider).navigateToInputScreen,
          ),
        ],
      ),
    );
  }
}
