import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/cache/locale_manager.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/utils/ui/popup.dart';
import '../../../../product/enums/locale_manager_enums.dart';
import '../model/firm_model.dart';
import '../viewmodel/login_viewmodel.dart';

class EditFirmView extends ConsumerStatefulWidget {
  ChangeNotifierProvider<LoginViewModel> provider;
  FirmModel firmModel;
  EditFirmView({
    Key? key,
    required this.provider,
    required this.firmModel,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditFirmViewState();
}

class _EditFirmViewState extends ConsumerState<EditFirmView> {
  late FirmModel newModel;

  @override
  void initState() {
    newModel = FirmModel.copy(widget.firmModel);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firma Düzenle'),
        centerTitle: true,
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "save",
            onPressed: () async {
              if (await ref
                  .read<LoginViewModel>(widget.provider)
                  .editFirm(newModel)) {
                PopupHelper.showSimpleSnackbar("Firma düzenlendi");
                NavigationService.instance.back();
              } else {
                PopupHelper.showSimpleSnackbar("Firma düzenlenemedi",
                    error: true);
              }
            },
            child: const Icon(Icons.check),
          ),
          FloatingActionButton(
            heroTag: "delete",
            onPressed: () async {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.WARNING,
                animType: AnimType.BOTTOMSLIDE,
                title: "Firma Sil",
                desc: "Firma silmek istediğinize emin misiniz?",
                btnCancelText: "İptal",
                btnOkColor: Colors.red,
                btnOkIcon: Icons.check,
                btnOkText: "Evet",
                btnOkOnPress: () async {
                  if (await ref
                      .read<LoginViewModel>(widget.provider)
                      .deleteFirm(newModel)) {
                    LocaleManager.instance
                        .remove(LocaleManagerEnums.defaultFirmId.name);
                    PopupHelper.showSimpleSnackbar("Firma silindi");
                    NavigationService.instance.back();
                  } else {
                    PopupHelper.showSimpleSnackbar("Firma silinemedi",
                        error: true);
                  }
                },
                btnCancelColor: Colors.green,
                btnCancelOnPress: () {},
                btnCancelIcon: Icons.delete,
              ).show();
            },
            child: const Icon(Icons.delete),
          )
        ],
      ),
      body: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
                initialValue: newModel.name,
                onChanged: (value) {
                  newModel.name = value;
                },
                decoration: const InputDecoration(labelText: 'Firma')),
            TextFormField(
                initialValue: newModel.serverIp,
                onChanged: (value) {
                  newModel.serverIp = value;
                },
                decoration: const InputDecoration(labelText: 'Server ip')),
            TextFormField(
                initialValue: newModel.username,
                onChanged: (value) {
                  newModel.username = value;
                },
                decoration:
                    const InputDecoration(labelText: 'Server Kullanıcı adı')),
            TextFormField(
                initialValue: newModel.password,
                onChanged: (value) {
                  newModel.password = value;
                },
                decoration: const InputDecoration(labelText: 'Server Şifre')),
            TextFormField(
                initialValue: newModel.database,
                onChanged: (value) {
                  newModel.database = value;
                },
                decoration: const InputDecoration(labelText: 'Database')),
          ],
        ),
      ),
    );
  }
}
