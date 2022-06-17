import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/utils/ui/popup.dart';
import '../model/firm_model.dart';
import '../viewmodel/login_viewmodel.dart';

class AddFirmView extends ConsumerStatefulWidget {
  ChangeNotifierProvider<LoginViewModel> provider;
  AddFirmView({Key? key, required this.provider}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddFirmViewState();
}

class _AddFirmViewState extends ConsumerState<AddFirmView> {
  FirmModel model = FirmModel.empty();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firma ekle'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () async {
          if (await ref.read(widget.provider).addFirm(model)) {
            PopupHelper.showSimpleSnackbar('Firma eklendi');
            NavigationService.instance.back();
          } else {
            PopupHelper.showSimpleSnackbar('Firma eklenemedi');
          }
        },
      ),
      body: Form(
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            TextFormField(
                initialValue: model.database,
                onChanged: (value) {
                  model.name = value;
                },
                decoration: const InputDecoration(labelText: 'Firma')),
            TextFormField(
                initialValue: model.serverIp,
                onChanged: (value) {
                  model.serverIp = value;
                },
                decoration: const InputDecoration(labelText: 'Server ip')),
            TextFormField(
                initialValue: model.username,
                onChanged: (value) {
                  model.username = value;
                },
                decoration:
                    const InputDecoration(labelText: 'Server Kullanıcı adı')),
            TextFormField(
                initialValue: model.password,
                onChanged: (value) {
                  model.password = value;
                },
                decoration: const InputDecoration(labelText: 'Server Şifre')),
            TextFormField(
                initialValue: model.database,
                onChanged: (value) {
                  model.database = value;
                },
                decoration: const InputDecoration(labelText: 'Database')),
          ]),
        ),
      ),
    );
  }
}
