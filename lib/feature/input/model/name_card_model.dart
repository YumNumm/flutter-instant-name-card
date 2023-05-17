import 'package:flutter_name_card_printer/feature/input/model/sns_account_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'name_card_model.freezed.dart';
part 'name_card_model.g.dart';

@freezed
class NameCardModel with _$NameCardModel {
  const factory NameCardModel({
    /// 名前
    @Default('') String name,
    @Default(null) String? nameKana,
    @Default(null) String? nameEng,

    /// 所属組織
    @Default(null) String? organization,
    @Default(null) String? orgnizationIconUrl,
    @Default(null) bool? isOrganizationIconUrlValid,

    /// 役職
    @Default(null) String? position,

    /// 電話番号
    @Default(null) String? phoneNumber,

    /// メールアドレス
    @Default(null) String? mailAddress,

    /// Webサイト
    @Default(null) String? website,

    /// SNS
    @Default([]) List<SnsAccountModel> snsAccounts,
  }) = _NameCardModel;

  factory NameCardModel.fromJson(Map<String, dynamic> json) =>
      _$NameCardModelFromJson(json);
}

enum SnsType {
  twitter,
  facebook,
  instagram,
  linkedin,
  github,
  qiita,
  zenn,
  note,
  other;
}

String snsTypeToJson(SnsType snsType) => snsType.name;
SnsType snsTypeFromJson(String json) =>
    SnsType.values.firstWhere((e) => e.name == json);
