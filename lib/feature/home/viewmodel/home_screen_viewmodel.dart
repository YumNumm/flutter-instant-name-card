import 'package:flutter_name_card_printer/feature/common/router/router_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_screen_viewmodel.g.dart';

@riverpod
HomeScreenViewModel homeScreenViewModel(HomeScreenViewModelRef ref) =>
    HomeScreenViewModel(ref);

class HomeScreenViewModel {
  HomeScreenViewModel(this.ref);
  final HomeScreenViewModelRef ref;

  /// 情報入力画面へ遷移
  void navigateToInputScreen() => ref.read(goRouterProvider).push<void>(
        const InputRoute().location,
      );

  void navigateToSettingScreen() => ref.read(goRouterProvider).push<void>(
        const SettingRoute().location,
      );
}
