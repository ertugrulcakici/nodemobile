import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nodemobile/core/services/navigation/navigation_service.dart';
import 'package:nodemobile/product/models/sevkiyat_baslik_ozet_model.dart';
import 'package:nodemobile/view/modules/malzeme_fisleri/subpages/sevkiyat_fisi_ayrinti/view/sevkiyat_fisi_icerik_view.dart';
import 'package:nodemobile/view/modules/malzeme_fisleri/subpages/sevkiyat_fisleri_listesi/viewmodel/sevkiyat_fisleri_listesi_viewmodel.dart';

class SevkiyatFisleriListesiView extends ConsumerStatefulWidget {
  const SevkiyatFisleriListesiView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SevkiyatFisleriViewState();
}

class _SevkiyatFisleriViewState
    extends ConsumerState<SevkiyatFisleriListesiView> {
  ChangeNotifierProvider<SevkiyatFisleriListesiViewModel> provider =
      ChangeNotifierProvider((ref) => SevkiyatFisleriListesiViewModel());

  @override
  void initState() {
    ref.read(provider).fillSevkiyatBasliklari();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sevkiyat fişleri"), centerTitle: true),
      body: ListView.builder(
        itemCount: ref.watch(provider).sevkiyatBasliklari.length,
        itemBuilder: (context, index) {
          SevkiyatBaslikOzetModel baslik =
              ref.watch(provider).sevkiyatBasliklari[index];
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ListTile(
                subtitle: Text(baslik.toPrettyString()),
                onTap: () {
                  NavigationService.instance.navigateToWidget(
                      widget: SevkiyatFisiIcerikView(baslik: baslik));
                },
              ),
              const Divider()
            ],
          );
        },
      ),
    );
  }
}
