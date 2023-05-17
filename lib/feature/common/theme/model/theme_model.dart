// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'theme_model.freezed.dart';
part 'theme_model.g.dart';

@freezed
class ThemeModel with _$ThemeModel {
  const factory ThemeModel({
    /// テーマモード
    @JsonKey(fromJson: themeModeFromJson, toJson: themeModeToJson)
    @Default(ThemeMode.system)
        ThemeMode themeMode,

    /// 可能な場合にダイナミックカラーを使用するかどうか
    @Default(true)
        bool useDynamicColor,
  }) = _ThemeModel;

  factory ThemeModel.fromJson(Map<String, dynamic> json) =>
      _$ThemeModelFromJson(json);
}

enum ThemeMode {
  system,
  light,
  dark;
}

Map<String, dynamic> themeModeToJson(ThemeMode themeMode) =>
    {'themeMode': themeMode.name};

ThemeMode themeModeFromJson(Map<String, dynamic> json) =>
    ThemeMode.values.firstWhere((e) => e.name == json['themeMode']);
