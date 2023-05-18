import 'package:flutter/material.dart';
import 'package:flutter_name_card_printer/feature/input/viewmodel/input_view_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class InputScreen extends ConsumerWidget {
  const InputScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(inputViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('名刺の内容を入力'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _ListSectionWidget(title: '名前'),
            ListTile(
              title: const Text('名前'),
              subtitle: Text(state.name),
              onTap: () async {
                final name = await _showTextFieldDialog(
                  context,
                  title: '名前',
                  hintText: '名前を入力してください',
                  labelText: '名前',
                );
                if (name != null) {
                  ref.read(inputViewModelProvider.notifier).setName(name);
                }
              },
            ),
            Text(state.toString()),
          ],
        ),
      ),
    );
  }

  /// 汎用TextField Dialog
  Future<String?> _showTextFieldDialog(
    BuildContext context, {
    required String title,
    required String hintText,
    required String labelText,
    String cancelText = 'キャンセル',
    String okText = 'OK',
  }) async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              labelText: labelText,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(cancelText),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: Text(okText),
            ),
          ],
        );
      },
    );
  }
}

class _ListSectionWidget extends StatelessWidget {
  const _ListSectionWidget({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Container(
      padding: const EdgeInsets.only(top: 16, bottom: 10, left: 20),
      child: Text(
        title,
        style: TextStyle(
          color: t.colorScheme.primary,
        ),
      ),
    );
  }
}
