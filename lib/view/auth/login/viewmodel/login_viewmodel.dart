import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/services/cache/locale_manager.dart';
import '../../../../core/services/database/database_helper.dart';
import '../../../../core/services/database/database_service.dart';
import '../../../../core/utils/ui/popup.dart';
import '../../../../product/enums/locale_manager_enums.dart';
import '../model/firm_model.dart';

class LoginViewModel extends ChangeNotifier {
  List<FirmModel> firmList = [];

  bool fabActive = true;

  FirmModel? get defaultFirm {
    if (firmList.isEmpty) {
      return null;
    } else {
      if (firmList.any((element) => element.isDefault)) {
        final firm = firmList.firstWhere((element) => element.isDefault);
        setDefaultLoginData(firm);
        return firm;
      } else {
        return null;
      }
    }
  }

  TextEditingController usernameController;
  TextEditingController passwordController;
  LoginViewModel(
      {required this.usernameController, required this.passwordController});

  Future<bool> login(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      PopupHelper.showSimpleSnackbar("Kullanıcı adı veya şifre boş olamaz",
          error: true);
      return false;
    } else {
      try {
        final result = await DatabaseService.instance.firmDb.rawQuery(
            "select * from X_Users where LogonName = '$username' and Password = '$password'");
        if (result.isEmpty) {
          PopupHelper.showSimpleSnackbar("Kullanıcı adı veya şifre hatalı",
              error: true);
          return false;
        } else {
          LocaleManager.instance.setInt(
              LocaleManagerEnums.loggedUserId, result.first["ID"] as int);
          if (LocaleManager.instance.getBool(LocaleManagerEnums.rememberMe) ??
              false) {
            try {
              await DatabaseService.instance.userDb.execute(
                  "update X_Firms set defaultUsername = '$username', defaultPassword = '$password' where FirmNr = ${LocaleManager.instance.getInt(LocaleManagerEnums.defaultFirmId)}");
            } catch (e) {
              log("default kaydedilmedi. Hata: $e");
            }
          }
          return true;
        }
      } catch (e) {
        PopupHelper.showSimpleSnackbar("Öncelikle bir firma seçmelisin",
            error: true);
        return false;
      }
    }
  }

  Future<bool> addFirm(FirmModel model) async {
    bool done = true;
    try {
      fabActive = false;
      notifyListeners();
      await DatabaseHelper.instance.firmManager.addFirm(model);
      int lastFirmId =
          await DatabaseHelper.instance.firmManager.getLastFirmId();
      model.id = lastFirmId;
      if (await setDefaultFirm(model)) {
        try {
          await DatabaseService.instance.initFirmDatabase(lastFirmId);
          done = true;
        } catch (e) {
          await deleteFirm(model);
          done = false;
        }
      } else {
        done = false;
      }
    } catch (e) {
      done = false;
    } finally {
      fabActive = true;
    }
    if (!done) {
      try {
        int lastFirmId =
            await DatabaseHelper.instance.firmManager.getLastFirmId();
        await DatabaseService.instance.userDb
            .execute("delete from X_Firms where ID = $lastFirmId");
      } catch (e) {
        log("Firma silinemedi. Hata: $e");
      }
    }
    getFirms();
    return done;
  }

  Future<bool> getFirms() async {
    try {
      firmList = await DatabaseHelper.instance.firmManager.getFirms();
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteFirm(FirmModel model) async {
    try {
      int result = await DatabaseHelper.instance.firmManager.deleteFirm(model);
      if (result > 0) {
        if (model.isDefault) {
          LocaleManager.instance.remove(LocaleManagerEnums.defaultFirmId);
          File(DatabaseService.instance.firmDb.path).deleteSync();
        }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    } finally {
      getFirms();
    }
  }

  Future<bool> editFirm(FirmModel model) async {
    try {
      int result = await DatabaseHelper.instance.firmManager.editFirm(model);
      if (result > 0) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log("Hata: $e");
      return false;
    } finally {
      getFirms();
    }
  }

  Future<bool> setDefaultFirm(FirmModel model) async {
    if (await LocaleManager.instance
        .setInt(LocaleManagerEnums.defaultFirmId, model.id!)) {
      await DatabaseService.instance.initFirmDatabase(model.id);
      return getFirms();
    } else {
      return false;
    }
  }

  Future setDefaultLoginData(FirmModel model) async {
    if (LocaleManager.instance.getBool(LocaleManagerEnums.rememberMe) ??
        false) {
      Map<String, dynamic>? defaultUserData =
          await DatabaseHelper.instance.firmManager.getDefaultFirmUser(model);
      if (defaultUserData != null) {
        usernameController.text = defaultUserData["defaultUsername"] ?? "";
        passwordController.text = defaultUserData["defaultPassword"] ?? "";
      }
    }
  }
}
