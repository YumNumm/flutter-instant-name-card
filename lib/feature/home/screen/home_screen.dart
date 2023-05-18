import 'package:flutter/material.dart';
import 'package:flutter_name_card_printer/feature/home/viewmodel/home_screen_viewmodel.dart';
import 'package:flutter_name_card_printer/feature/input/model/name_card_model.dart';
import 'package:flutter_name_card_printer/feature/input/viewmodel/input_view_model.dart';
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: ref.read(inputViewModelProvider.notifier).printNameCard,
        label: const Text('印刷'),
        icon: const Icon(Icons.print),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: const Text('名刺の内容を入力する'),
              leading: const Icon(Icons.input),
              onTap:
                  ref.read(homeScreenViewModelProvider).navigateToInputScreen,
            ),
            NameCardInformationWidget(
              nameCard: ref.watch(inputViewModelProvider),
            ),
          ],
        ),
      ),
    );
  }
}

class NameCardInformationWidget extends StatelessWidget {
  const NameCardInformationWidget({required this.nameCard, super.key});

  final NameCardModel nameCard;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(),
            Text('名前: ${nameCard.name}'),
            Text('名前(サブ): ${nameCard.nameSub ?? ""}'),
            const Divider(),
            Text('所属組織: ${nameCard.organization ?? ""}'),
            Text('役職: ${nameCard.position ?? ""}'),
            if (nameCard.organizationIconUrl != null)
              Center(
                child: Card(
                  elevation: 0,
                  color: Theme.of(context)
                      .colorScheme
                      .onPrimaryContainer
                      .withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Image.network(
                      nameCard.organizationIconUrl!,
                      width: 100,
                      height: 100,
                      errorBuilder: (_, __, ___) => const Column(
                        children: [
                          Icon(Icons.error),
                          Text('組織アイコンの取得に失敗しました。')
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            const Divider(),
            Text('電話番号: ${nameCard.phoneNumber ?? ""}'),
            Text('メールアドレス: ${nameCard.email ?? ""}'),
            Text('Webサイト: ${nameCard.website ?? ""}'),
            const Divider(),
            const Text('SNS'),
            for (final snsAccount in nameCard.snsAccounts)
              Text('${snsAccount.type.name}: ${snsAccount.name}'),
          ],
        ),
      ),
    );
  }
}
