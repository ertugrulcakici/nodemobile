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
                  title: Text(e.keys.first),
                  subtitle: Text(e.values.first.toString()),
                  trailing: IconButton(
                      onPressed: () {
                        ref.read(provider).deleteFis(e.values.first);
                      },
                      icon: const Icon(Icons.delete)),
                ))
            .toList(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                flex: 2,
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Fiş adı",
                    hintText: "Fiş adı",
                    border: OutlineInputBorder(),
                  ),
                )),
            Expanded(
                flex: 1,
                child:
                    IconButton(onPressed: () {}, icon: const Icon(Icons.add))),
            Expanded(
                flex: 2,
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Fiş no",
                    hintText: "Fiş no",
                    border: OutlineInputBorder(),
                  ),
                )),
          ],
        ),
      ],
    );
  }
}
