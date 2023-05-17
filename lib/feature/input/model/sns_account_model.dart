import 'package:flutter_name_card_printer/feature/input/model/name_card_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'sns_account_model.freezed.dart';
part 'sns_account_model.g.dart';

@freezed
class SnsAccountModel with _$SnsAccountModel {
  const factory SnsAccountModel({
    required SnsType type,
    required String name,
  }) = _SnsAccountModel;

  factory SnsAccountModel.fromJson(Map<String, dynamic> json) =>
      _$SnsAccountModelFromJson(json);
}
