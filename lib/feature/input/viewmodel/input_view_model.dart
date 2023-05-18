import 'dart:convert';

import 'package:flutter_name_card_printer/feature/common/provider/shared_preferences.dart';
import 'package:flutter_name_card_printer/feature/input/model/name_card_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'input_view_model.g.dart';

@Riverpod(keepAlive: true)
class InputViewModel extends _$InputViewModel {
  @override
  NameCardModel build() {
    prefs = ref.read(sharedPreferencesProvider);
    return _loadInputState();
  }

  late final SharedPreferences prefs;

  static const _prefsKey = 'name';

  NameCardModel _loadInputState() {
    final data = prefs.getString(_prefsKey);
    if (data != null) {
      return NameCardModel.fromJson(
        jsonDecode(data) as Map<String, dynamic>,
      );
    }
    return const NameCardModel();
  }

  void setName(String name) => state = state.copyWith(name: name);
}
