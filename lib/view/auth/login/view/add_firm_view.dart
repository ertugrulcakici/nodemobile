import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/utils/ui/popup.dart';
import '../model/firm_model.dart';
import '../viewmodel/login_viewmodel.dart';

class AddFirmView extends ConsumerStatefulWidget {
  final ChangeNotifierProvider<LoginViewModel> provider;
  const AddFirmView({Key? key, required this.provider}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddFirmViewState();
}

class _AddFirmViewState extends ConsumerState<AddFirmView> {
  FirmModel model = FirmModel.empty();

  @override
  void initState() {
    // model.serverIp = "192.168.1.58";
    // model.database = "ARIKREAL";
    // model.username = "sa";
    // model.password = "ertuertu27";
    // model.name = "deneme";
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
        onPressed: _fab,
        child: const Icon(Icons.save),
      ),
      body: Form(
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            TextFormField(
                initialValue: model.name,
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

  void _fab() async {
    if (ref.watch(widget.provider).fabActive) {
      if (await ref.read(widget.provider).addFirm(model)) {
        PopupHelper.showSimpleSnackbar('Firma eklendi');
        NavigationService.instance.back();
      } else {
        PopupHelper.showSimpleSnackbar('Firma eklenemedi');
      }
    }
  }
}
