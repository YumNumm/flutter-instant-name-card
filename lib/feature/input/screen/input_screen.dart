import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_name_card_printer/feature/input/model/name_card_model.dart';
import 'package:flutter_name_card_printer/feature/input/model/sns_account_model.dart';
import 'package:flutter_name_card_printer/feature/input/viewmodel/input_view_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class InputScreen extends ConsumerWidget {
  const InputScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(inputViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('名刺の内容を入力'),
        actions: [
          // loadQR
          IconButton(
            onPressed: () async {
              final result = await showModalBottomSheet<String?>(
                context: context,
                builder: (context) {
                  return const LoadQr();
                },
              );
              if (result == null) {
                return;
              }
              try {
                ref
                    .read(inputViewModelProvider.notifier)
                    .loadFromQrString(result);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('読み取りに成功しました'),
                    ),
                  );
                }
              } on Exception catch (e) {
                if (context.mounted) {
                  // snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                    ),
                  );
                }
              }
            },
            icon: const Icon(Icons.qr_code_scanner),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: ref.read(inputViewModelProvider.notifier).exportAsQRCode,
//        onPressed: ref.read(inputViewModelProvider.notifier).printNameCard,
        label: const Text(
          '名刺情報をQRコードでエクスポート',
        ),
        icon: const Icon(Icons.qr_code),
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
                  defaultText: state.name,
                );
                if (name != null) {
                  ref.read(inputViewModelProvider.notifier).setName(name);
                }
              },
            ),
            ListTile(
              title: const Text('名前(英語・かな)'),
              subtitle: Text(state.nameSub ?? ''),
              onTap: () async {
                final nameSub = await _showTextFieldDialog(
                  context,
                  title: '名前(英語・かな)',
                  hintText: '名前(英語・かな)を入力してください',
                  labelText: '名前(英語・かな)',
                  defaultText: state.nameSub,
                );
                if (nameSub != null) {
                  ref.read(inputViewModelProvider.notifier).setNameSub(nameSub);
                }
              },
            ),
            const _ListSectionWidget(title: '所属組織'),
            ListTile(
              title: const Text('所属組織'),
              subtitle: Text(state.organization ?? ''),
              onTap: () async {
                final organization = await _showTextFieldDialog(
                  context,
                  title: '所属組織',
                  hintText: '所属組織を入力してください',
                  labelText: '所属組織',
                  defaultText: state.organization,
                );
                if (organization != null) {
                  ref
                      .read(inputViewModelProvider.notifier)
                      .setOrganization(organization);
                }
              },
            ),
            ListTile(
              title: const Text('所属組織アイコンURL'),
              subtitle: Text(state.organizationIconUrl ?? ''),
              onTap: () async {
                final organizationIconUrl = await _showTextFieldDialog(
                  context,
                  title: '所属組織アイコンURL',
                  hintText: '所属組織アイコンURLを入力してください',
                  labelText: '所属組織アイコンURL',
                  defaultText: state.organizationIconUrl,
                  enableQr: true,
                );
                if (organizationIconUrl != null) {
                  ref
                      .read(inputViewModelProvider.notifier)
                      .setOrganizationIconUrl(organizationIconUrl);
                }
              },
              trailing: state.organizationIconUrl != null
                  ? Image.network(
                      state.organizationIconUrl!,
                      width: 30,
                      height: 30,
                      errorBuilder: (_, __, ___) => const Icon(Icons.error),
                    )
                  : null,
            ),
            const _ListSectionWidget(title: '役職'),
            ListTile(
              title: const Text('役職'),
              subtitle: Text(state.position ?? ''),
              onTap: () async {
                final position = await _showTextFieldDialog(
                  context,
                  title: '役職',
                  hintText: '役職を入力してください',
                  labelText: '役職',
                  defaultText: state.position,
                );
                if (position != null) {
                  ref
                      .read(inputViewModelProvider.notifier)
                      .setPosition(position);
                }
              },
            ),
            const _ListSectionWidget(title: '個人情報'),
            ListTile(
              title: const Text('電話番号'),
              subtitle: Text(state.phoneNumber ?? ''),
              onTap: () async {
                final phoneNumber = await _showTextFieldDialog(
                  context,
                  title: '電話番号',
                  hintText: '電話番号を入力してください',
                  labelText: '電話番号',
                  type: TextInputType.phone,
                  defaultText: state.phoneNumber,
                );
                if (phoneNumber != null) {
                  ref
                      .read(inputViewModelProvider.notifier)
                      .setPhoneNumber(phoneNumber);
                }
              },
            ),
            ListTile(
              title: const Text('メールアドレス'),
              subtitle: Text(state.email ?? ''),
              onTap: () async {
                final email = await _showTextFieldDialog(
                  context,
                  title: 'メールアドレス',
                  hintText: 'メールアドレスを入力してください',
                  labelText: 'メールアドレス',
                  type: TextInputType.emailAddress,
                  defaultText: state.email,
                );
                if (email != null) {
                  ref.read(inputViewModelProvider.notifier).setEmail(email);
                }
              },
            ),
            ListTile(
              title: const Text('Webサイト'),
              subtitle: Text(state.website ?? ''),
              onTap: () async {
                final website = await _showTextFieldDialog(
                  context,
                  title: 'Webサイト',
                  hintText: 'Webサイトを入力してください',
                  labelText: 'Webサイト',
                  type: TextInputType.url,
                  defaultText: state.website,
                );
                if (website != null) {
                  ref.read(inputViewModelProvider.notifier).setWebsite(website);
                }
              },
            ),
            const _ListSectionWidget(title: 'SNS'),
            for (final type in SnsType.values)
              ListTile(
                title: Text(type.name),
                subtitle: Text(
                  state.snsAccounts
                          .firstWhereOrNull((e) => e.type == type)
                          ?.name ??
                      '',
                ),
                onTap: () async {
                  final result = await _showTextFieldDialog(
                    context,
                    title: type.name,
                    hintText: '${type.name}のアカウント名を入力してください',
                    labelText: type.name,
                    type: TextInputType.emailAddress,
                    defaultText: state.snsAccounts
                            .firstWhereOrNull((e) => e.type == type)
                            ?.name ??
                        '',
                  );
                  if (result != null) {
                    ref.read(inputViewModelProvider.notifier).updateSnsAccount(
                          SnsAccountModel(
                            type: type,
                            name: result,
                          ),
                        );
                  }
                },
              ),
            const Padding(
              padding: EdgeInsets.all(8),
              child: Divider(),
            ),
            Text(const JsonEncoder.withIndent('  ').convert(state)),
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
    required String? defaultText,
    TextInputType type = TextInputType.text,
    String cancelText = 'キャンセル',
    String okText = 'OK',
    bool enableQr = false,
  }) async {
    final controller = TextEditingController(
      text: defaultText,
    );
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                keyboardType: type,
                controller: controller,
                decoration: InputDecoration(
                  hintText: hintText,
                  labelText: labelText,
                ),
              ),
              if (enableQr)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final result = await showModalBottomSheet<String?>(
                        context: context,
                        builder: (context) {
                          return const LoadQr();
                        },
                      );
                      if (result == null) {
                        return;
                      }
                      controller.text = result;
                    },
                    icon: const Icon(Icons.qr_code),
                    label: const Text('QRコードから読み込む'),
                  ),
                )
            ],
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

class LoadQr extends StatelessWidget {
  const LoadQr({super.key});

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      onDetect: (barcodes) {
        Navigator.pop(context, barcodes.barcodes.first.rawValue.toString());
      },
    );
  }
}
