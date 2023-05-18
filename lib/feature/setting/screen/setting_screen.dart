import 'package:flutter/material.dart';
import 'package:flutter_name_card_printer/feature/common/theme/provider/theme_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingScreen extends ConsumerWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeStateProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: const Text('テーマモード'),
              subtitle: Text(themeMode.themeMode.name),
              onTap: () async {
                final themeMode = await showDialog<ThemeMode>(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                      title: const Text('テーマモードを選択してください'),
                      children: [
                        SimpleDialogOption(
                          padding: const EdgeInsets.all(16),
                          onPressed: () =>
                              Navigator.pop(context, ThemeMode.system),
                          child: const Text('システム設定に従う'),
                        ),
                        SimpleDialogOption(
                          padding: const EdgeInsets.all(16),
                          onPressed: () =>
                              Navigator.pop(context, ThemeMode.light),
                          child: const Text('ライトモード'),
                        ),
                        SimpleDialogOption(
                          padding: const EdgeInsets.all(16),
                          onPressed: () =>
                              Navigator.pop(context, ThemeMode.dark),
                          child: const Text('ダークモード'),
                        ),
                      ],
                    );
                  },
                );
                if (themeMode != null) {
                  ref.read(themeStateProvider.notifier).setThemeMode(themeMode);
                }
              },
            ),
            ListTile(
              title: const Text('ライセンス情報'),
              subtitle: const Text('Ryotaro Onoue MIT License'),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: '即席名刺',
                  applicationLegalese: 'Ryotaro Onoue MIT License\n'
                      'https://github.com/YumNumm/flutter-instant-name-card',
                  applicationVersion: 'V1.0',
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
