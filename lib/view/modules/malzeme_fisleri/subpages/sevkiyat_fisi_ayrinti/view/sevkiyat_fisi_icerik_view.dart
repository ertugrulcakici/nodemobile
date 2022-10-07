import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:nodemobile/core/services/navigation/navigation_service.dart';
import 'package:nodemobile/product/models/sevkiyat_baslik_ozet_model.dart';
import 'package:nodemobile/view/modules/malzeme_fisleri/subpages/sevkiyat_fisi_ayrinti/view/sevkiyat_fis_satiri_view.dart';
import 'package:nodemobile/view/modules/malzeme_fisleri/subpages/sevkiyat_fisi_ayrinti/viewmodel/sevkiyat_fisi_icerik_viewmodel.dart';

class SevkiyatFisiIcerikView extends ConsumerStatefulWidget {
  final SevkiyatBaslikOzetModel baslik;
  const SevkiyatFisiIcerikView({Key? key, required this.baslik})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SevkiyatFisiIcerikViewState();
}

class _SevkiyatFisiIcerikViewState
    extends ConsumerState<SevkiyatFisiIcerikView> {
  late ChangeNotifierProvider<SevkiyatFisiIcerikViewModel> provider;
  late TextEditingController _barcodeController;

  bool state = false;
  @override
  void initState() {
    provider = ChangeNotifierProvider((ref) => SevkiyatFisiIcerikViewModel(
        widget.baslik,
        barcodeController: _barcodeController));
    _barcodeController = TextEditingController();
    ref.read(provider).getInitialLines().then((value) {
      ref.read(provider).getLocaleLines();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _barcodeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _appBar(context), body: _body());
  }

  AppBar _appBar(BuildContext context) =>
      AppBar(title: Text("Sevkiyat fiş ID: ${widget.baslik.id}"), actions: [
        IconButton(
            onPressed: ref.read(provider).savePrompt,
            icon: const Icon(Icons.check))
      ]);

  Padding _body() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _urunBilgileri(),
          _urunAramaFieldi(),
          _eklemeButonu(),
          _urunler(),
        ],
      ),
    );
  }

  Expanded _urunler() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(top: 16),
        decoration:
            BoxDecoration(border: Border.all(color: Colors.grey, width: 0.3)),
        child: ListView.builder(
            itemCount: ref.watch(provider).initialSatirlar.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> initialSatir =
                  ref.watch(provider).initialSatirlar[index];
              return Slidable(
                key: ValueKey(index.toString()),
                groupTag: 0,
                startActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      foregroundColor: Colors.black,
                      icon: Icons.info_outline,
                      onPressed: (context) {
                        NavigationService.instance
                            .navigateToWidget(SevkiyatFisSatiriView(
                          baslik: widget.baslik,
                          productId: initialSatir["PD"],
                          productName: initialSatir["UrunAd"],
                        ))
                            .then((value) {
                          log("geri geldi");
                          ref.read(provider).getLocaleLines();
                        });
                      },
                      backgroundColor: Colors.transparent,
                    ),
                  ],
                ),
                child: Container(
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.grey, width: 0.3))),
                  child: ListTile(
                    title: Text("Ürün adı: ${initialSatir["UrunAd"]}"),
                    subtitle: Text(
                        "Barkod: ${initialSatir["Barkod"]}\nMiktar: ${initialSatir["Miktar"]}\nYüklenen ${initialSatir["Yuklenen"]}\nKalan ${double.parse(initialSatir["Miktar"].toString()) - double.parse(initialSatir["Yuklenen"].toString())}"),
                  ),
                ),
              );
            }),
      ),
    );
  }

  InkWell _eklemeButonu() {
    return InkWell(
      onTap: () {
        ref.read(provider).addLineToLocale();
      },
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(50)),
            color: Colors.blue.shade300),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
                child: Text("Ekle",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.sp,
                        color: Colors.white))),
            const Icon(Icons.arrow_forward_ios, color: Colors.white)
          ],
        ),
      ),
    );
  }

  TextField _urunAramaFieldi() {
    return TextField(
      controller: _barcodeController,
      onSubmitted: (text) {
        ref.read(provider).getProductByBarcode(text);
      },
      decoration: InputDecoration(
          labelText: "Barkod",
          hintText: "Barkod",
          suffixIcon: IconButton(
              onPressed: ref.read(provider).readBarcode,
              icon: const Icon(Icons.camera_alt))),
    );
  }

  _urunBilgileri() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 0.3),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  "Ürün adı: ${(ref.watch(provider).urun?["Name"]).toString().replaceAll("null", "-")}"),
              Text(
                  "Lot no: ${(ref.watch(provider).urun?["LotID"]).toString().replaceAll("null", "-")}"),
              Text(
                  "Palet no:${(ref.watch(provider).urun?["BalyaNo"]).toString().replaceAll("null", "-")}"),
              Text(
                  "Paket no:${(ref.watch(provider).urun?["PaketNo"]).toString().replaceAll("null", "-")}"),
              Text(
                  "Miktar: ${(ref.watch(provider).urun?["Miktar"]).toString().replaceAll("null", "-")}"),
            ],
          ),
        ),
        Positioned(
            right: 10,
            bottom: 10,
            child: IconButton(
                onPressed: () {
                  ref.read(provider).urun = null;
                },
                icon: const Icon(Icons.clear))),
      ],
    );
  }
}
