import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nodemobile/core/services/navigation/navigation_service.dart';
import 'package:nodemobile/product/models/sevkiyat_baslik_ozet_model.dart';
import 'package:nodemobile/view/modules/malzeme_fisleri/subpages/sevkiyat_fisi_ayrinti/view/sevkiyat_fisi_icerik_view.dart';
import 'package:nodemobile/view/modules/malzeme_fisleri/subpages/sevkiyat_fisi_ayrinti/viewmodel/sevkiyat_fisi_baslik_viewmodel.dart';

class SevkiyatFisiBaslikView extends ConsumerStatefulWidget {
  SevkiyatBaslikOzetModel baslikOzet;
  late SevkiyatBaslikOzetModel baslikCopy;
  SevkiyatFisiBaslikView({Key? key, required this.baslikOzet})
      : super(key: key) {
    baslikCopy = baslikOzet.copy();
  }

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SevkiyatFisiBaslikViewState();
}

class _SevkiyatFisiBaslikViewState
    extends ConsumerState<SevkiyatFisiBaslikView> {
  late ChangeNotifierProvider<SevkiyatFisiBaslikViewModel> provider;
  @override
  void initState() {
    provider = ChangeNotifierProvider(
        (ref) => SevkiyatFisiBaslikViewModel(widget.baslikCopy));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _fab(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.05.sw, vertical: 0.05.sw),
        child: Container(
          padding: EdgeInsets.all(0.02.sw),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                    onChanged: (value) {
                      ref.watch(provider).baslikOzet.soforAdi = value;
                    },
                    initialValue: ref.watch(provider).baslikOzet.soforAdi,
                    onSaved: (value) =>
                        ref.read(provider).baslikOzet.soforAdi = value,
                    decoration: const InputDecoration(labelText: "Şoför adı")),
                TextFormField(
                    onChanged: (value) {
                      ref.watch(provider).baslikOzet.soforTC = value;
                    },
                    initialValue: ref.watch(provider).baslikOzet.soforTC,
                    onSaved: (value) =>
                        ref.read(provider).baslikOzet.soforTC = value,
                    decoration: const InputDecoration(labelText: "Şoför TC")),
                TextFormField(
                    onChanged: (value) {
                      ref.watch(provider).baslikOzet.soforTelefon = value;
                    },
                    initialValue: ref.watch(provider).baslikOzet.soforTelefon,
                    onSaved: (value) =>
                        ref.read(provider).baslikOzet.soforTelefon = value,
                    decoration:
                        const InputDecoration(labelText: "Şoför Telefonu")),
                TextFormField(
                    onChanged: (value) {
                      ref.watch(provider).baslikOzet.konteynerAracPlaka = value;
                    },
                    initialValue:
                        ref.watch(provider).baslikOzet.konteynerAracPlaka,
                    onSaved: (value) => ref
                        .read(provider)
                        .baslikOzet
                        .konteynerAracPlaka = value,
                    decoration:
                        const InputDecoration(labelText: "Araç plakası")),
                TextFormField(
                    onChanged: (value) {
                      ref.watch(provider).baslikOzet.dorsePlaka = value;
                    },
                    initialValue: ref.watch(provider).baslikOzet.dorsePlaka,
                    onSaved: (value) =>
                        ref.read(provider).baslikOzet.dorsePlaka,
                    decoration:
                        const InputDecoration(labelText: "Dorse plaka")),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: TextButton.icon(
                          onPressed: ref.read(provider).selectBranch,
                          icon: const Icon(Icons.edit),
                          label: Text(
                              "İş yeri: ${ref.watch(provider).branchString}")),
                    ),
                    Expanded(
                      child: TextButton.icon(
                          onPressed: ref.read(provider).selectDepo,
                          icon: const Icon(Icons.edit),
                          label:
                              Text("Depo: ${ref.watch(provider).depoString}")),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _fab() {
    return FloatingActionButton(
      onPressed: () async {
        if (await ref.read(provider).save()) {
          widget.baslikOzet = ref.read(provider).baslikOzet;
          NavigationService.instance.navigateToInstead(
              widget: SevkiyatFisiIcerikView(baslik: widget.baslikOzet));
        }
      },
      child: const Icon(Icons.check),
    );
  }
}
