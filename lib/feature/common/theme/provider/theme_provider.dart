import 'dart:convert';

import 'package:flutter_name_card_printer/feature/common/provider/shared_preferences.dart';
import 'package:flutter_name_card_printer/feature/common/theme/model/theme_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_provider.g.dart';

@Riverpod(
  dependencies: [
    sharedPreferences,
  ],
)
class ThemeState extends _$ThemeState {
  @override
  ThemeModel build() {
    _prefs = ref.read(sharedPreferencesProvider);
    // Stateの復元
    _loadThemeMode();
    // state変化時に保存するListner
    ref.listenSelf((_, next) => _saveThemeMode(next));
    return const ThemeModel();
  }

  static const _themeModeKey = 'themeMode';
  late final SharedPreferences _prefs;

  ThemeModel _loadThemeMode() {
    final data = _prefs.getString(_themeModeKey);
    if (data == null) {
      return const ThemeModel();
    }
    return ThemeModel.fromJson(
      jsonDecode(data) as Map<String, dynamic>,
    );
  }

  void _saveThemeMode(ThemeModel themeModel) {
    _prefs.setString(
      _themeModeKey,
      jsonEncode(themeModel.toJson()),
    );
  }
}
