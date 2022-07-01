import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nodemobile/view/settings/viewmodel/settings_viewmodel.dart';

class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> {
  ChangeNotifierProvider<SettingsViewModel> provider =
      ChangeNotifierProvider<SettingsViewModel>((ref) => SettingsViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
    );
  }

  _appBar() {
    return AppBar(
      title: const Text("Ayarlar"),
      centerTitle: true,
    );
  }

  _body() {
    return Column(children: [_fisler(), const Divider()]);
  }

  _fisler() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...ref
            .watch(provider)
            .fisler
            .map((e) => ListTile(
                  onTap: () {
                    ref.read(provider).editingId = e["FisType"];
                  },
                  title: ref.watch(provider).editingId == e["FisType"]
                      ? TextFormField(
                          initialValue: e.values.last,
                          onFieldSubmitted: (value) {
                            ref.read(provider).fisUpdate(value, e["FisType"]);
                          },
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: e.values.last.toString()),
                        )
                      : Text(e.values.last),
                ))
            .toList(),
      ],
    );
  }
}
