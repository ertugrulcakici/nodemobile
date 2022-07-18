import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nodemobile/product/models/sevkiyat_baslik_ozet_model.dart';
import 'package:nodemobile/view/modules/malzeme_fisleri/subpages/sevkiyat_fisi_ayrinti/viewmodel/sevkiyat_fis_satiri_viewmodel.dart';

class SevkiyatFisSatiriView extends ConsumerStatefulWidget {
  final SevkiyatBaslikOzetModel baslik;
  final int productId;
  final String productName;
  const SevkiyatFisSatiriView(
      {Key? key,
      required this.baslik,
      required this.productId,
      required this.productName})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SevkiyatFisSatiriViewState();
}

class _SevkiyatFisSatiriViewState extends ConsumerState<SevkiyatFisSatiriView> {
  late ChangeNotifierProvider<SevkiyatFisSatiriViewModel> provider;

  @override
  void initState() {
    provider = ChangeNotifierProvider((ref) => SevkiyatFisSatiriViewModel(
        baslik: widget.baslik, productId: widget.productId));
    ref.read(provider).getLines();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.productName),
      ),
      body: ListView.builder(
        itemCount: ref.watch(provider).lines.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text("Barkod:${ref.watch(provider).lines[index]["SeriNo"]}"),
            subtitle: Text(
                "Palet no:${ref.watch(provider).lines[index]["BalyaNo"].toString().replaceAll("null", "-")}.\nPaket no: ${ref.watch(provider).lines[index]["PaketNo"].toString().replaceAll("null", "-")}\nMiktar: ${ref.watch(provider).lines[index]["Amount"]}"),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.WARNING,
                  animType: AnimType.BOTTOMSLIDE,
                  title: 'Uyarı',
                  desc: 'Bu işlem geri alınamaz!',
                  btnOkOnPress: () {
                    ref.read(provider).deleteLine(index);
                  },
                  btnOkText: 'Evet',
                  btnCancelText: 'Hayır',
                  btnCancelOnPress: () {},
                ).show();
              },
            ),
          );
        },
      ),
    );
  }
}
