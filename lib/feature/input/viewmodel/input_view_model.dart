import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_name_card_printer/feature/common/provider/shared_preferences.dart';
import 'package:flutter_name_card_printer/feature/input/model/name_card_model.dart';
import 'package:flutter_name_card_printer/feature/input/model/sns_account_model.dart';
import 'package:image/image.dart' as Img;
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:sunmi_printer_plus/sunmi_style.dart';

part 'input_view_model.g.dart';

@Riverpod(keepAlive: true)
class InputViewModel extends _$InputViewModel {
  @override
  NameCardModel build() {
    prefs = ref.read(sharedPreferencesProvider);
    ref.listenSelf((_, next) => _saveInputState(next));
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

  void _saveInputState(NameCardModel state) {
    prefs.setString(_prefsKey, jsonEncode(state.toJson()));
  }

  void setName(String name) => state = state.copyWith(name: name);
  void setNameSub(String nameSub) => state = state.copyWith(nameSub: nameSub);
  void setOrganization(String organization) =>
      state = state.copyWith(organization: organization);
  void setOrganizationIconUrl(String organizationIconUrl) =>
      state = state.copyWith(organizationIconUrl: organizationIconUrl);
  void setPosition(String position) =>
      state = state.copyWith(position: position);
  void setPhoneNumber(String phoneNumber) =>
      state = state.copyWith(phoneNumber: phoneNumber);
  void setEmail(String email) => state = state.copyWith(email: email);
  void setWebsite(String website) => state = state.copyWith(website: website);
  void setSnsAccounts(List<SnsAccountModel> snsAccounts) =>
      state = state.copyWith(snsAccounts: snsAccounts);
  void updateSnsAccount(SnsAccountModel snsAcount) {
    final index = state.snsAccounts
        .indexWhere((element) => element.type == snsAcount.type);
    if (index >= 0) {
      final newSnsAccounts = state.snsAccounts;
      newSnsAccounts[index] = snsAcount;
      state = state.copyWith(snsAccounts: newSnsAccounts);
    }
    state = state.copyWith(snsAccounts: [...state.snsAccounts, snsAcount]);
  }

  Future<void> exportAsQRCode() async {
    final data = jsonEncode(state);
    // 圧縮する
    final compressedData = base64Encode(
      gzip.encode(
        utf8.encode(data),
      ),
    );
    await SunmiPrinter.lineWrap(2);
    await SunmiPrinter.printQRCode(
      compressedData,
      errorLevel: SunmiQrcodeLevel.LEVEL_L,
    );
    await SunmiPrinter.printText(
      "発行: ${DateFormat('yyyy/MM/dd HH:mm:ss').format(DateTime.now())}",
      style: SunmiStyle(
        bold: true,
      ),
    );
    await SunmiPrinter.lineWrap(2);
  }

  void loadFromQrString(String qrString) {
    final data = jsonDecode(
      utf8.decode(
        gzip.decode(
          base64Decode(qrString),
        ),
      ),
    ) as Map<String, dynamic>;
    state = NameCardModel.fromJson(data);
  }

  Future<void> printNameCard() async {
    await SunmiPrinter.initPrinter();
    await SunmiPrinter.lineWrap(2);
    // 名前
    await SunmiPrinter.printText(
      state.name,
      style: SunmiStyle(
        align: SunmiPrintAlign.CENTER,
        bold: true,
        fontSize: SunmiFontSize.LG,
      ),
    );
    if (state.nameSub != null) {
      await SunmiPrinter.printText(
        state.nameSub!,
        style: SunmiStyle(
          align: SunmiPrintAlign.CENTER,
          fontSize: SunmiFontSize.MD,
          bold: true,
        ),
      );
    }
    // line
    await SunmiPrinter.line();

    // 組織
    if (state.organization != null) {
      await SunmiPrinter.printText(
        state.organization!,
        style: SunmiStyle(
          align: SunmiPrintAlign.RIGHT,
          fontSize: SunmiFontSize.MD,
          bold: true,
        ),
      );
    }
    // 組織Image
    if (state.organizationIconUrl != null &&
        state.organizationIconUrl!.isNotEmpty) {
      log('message');
      await SunmiPrinter.startTransactionPrint();
      final url = state.organizationIconUrl!;
      final byte = (await NetworkAssetBundle(Uri.parse(url)).load(url))
          .buffer
          .asUint8List();
      final cmd = Img.Command()
        ..decodeImage(byte)
        ..grayscale(
          amount: 10,
        )
        ..copyResize(
          width: (384 * 0.5).toInt(),
        )
        ..encodeJpg();

      final image = await cmd.getBytes();

      await SunmiPrinter.setAlignment(SunmiPrintAlign.RIGHT);
      await SunmiPrinter.printImage(
        image!,
      );
      await SunmiPrinter.lineWrap(1);
      await SunmiPrinter.exitTransactionPrint();
    }
    // 職位
    if (state.position != null) {
      await SunmiPrinter.printText(
        state.position!,
        style: SunmiStyle(
          align: SunmiPrintAlign.CENTER,
          fontSize: SunmiFontSize.MD,
          bold: true,
        ),
      );
    }

    // line
    await SunmiPrinter.line();

    // 電話番号
    if (state.phoneNumber != null) {
      await SunmiPrinter.printText(
        'TEL: ${state.phoneNumber!}',
        style: SunmiStyle(
          fontSize: SunmiFontSize.MD,
          bold: true,
        ),
      );
    }

    // メールアドレス
    if (state.email != null) {
      await SunmiPrinter.printText(
        'Email: ${state.email!}',
        style: SunmiStyle(
          fontSize: SunmiFontSize.MD,
          bold: true,
        ),
      );
    }

    // Webサイト
    if (state.website != null) {
      await SunmiPrinter.printText(
        state.website!,
        style: SunmiStyle(
          fontSize: SunmiFontSize.MD,
          bold: true,
        ),
      );
    }

    // SNS
    for (final snsAccount in state.snsAccounts) {
      await SunmiPrinter.printText(
        '${snsAccount.type.name}: ${snsAccount.name}',
        style: SunmiStyle(
          fontSize: SunmiFontSize.MD,
          bold: true,
        ),
      );
    }

    await SunmiPrinter.lineWrap(2);
  }
}
