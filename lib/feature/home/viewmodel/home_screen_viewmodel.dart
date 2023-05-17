import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_screen_viewmodel.g.dart';

@riverpod
HomeScreenViewModel homeScreenViewModel(HomeScreenViewModelRef ref) =>
    HomeScreenViewModel(ref);

class HomeScreenViewModel {
  HomeScreenViewModel(this.ref);
  final HomeScreenViewModelRef ref;

  /// 情報入力画面へ遷移
  void navigateToInputScreen() {
    // final router = ref.read(goRouterProvider);
    // router.push();
  }
}
