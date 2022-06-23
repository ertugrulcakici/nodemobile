import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nodemobile/core/services/navigation/navigation_service.dart';
import 'package:nodemobile/core/utils/extentions/map_extention.dart';
import 'package:nodemobile/product/constants/database_constants.dart';
import 'package:nodemobile/product/models/fis_baslik_model.dart';
import 'package:nodemobile/view/modules/malzeme_fisleri/subpages/malzeme_fisi_olustur/viewmodel/fis_icerik_viewmodel.dart';
import 'package:nodemobile/view/modules/malzeme_fisleri/subpages/malzeme_fisleri_listesi/view/malzeme_fisleri_listesi.dart';

class FisIcerikView extends ConsumerStatefulWidget {
  final FisBasligiModel fisBasligiModel;
  const FisIcerikView({Key? key, required this.fisBasligiModel})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MalzemeFisiIcerikState();
}

class _MalzemeFisiIcerikState extends ConsumerState<FisIcerikView> {
  late ChangeNotifierProvider<FisIcerikViewModel> provider;
  final FocusNode countFocus = FocusNode();
  final FocusNode barcodeFocus = FocusNode();

  late GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController barcodeController = TextEditingController();
  final TextEditingController countController = TextEditingController();

  @override
  void initState() {
    provider = ChangeNotifierProvider((ref) => FisIcerikViewModel(
          fisBasligi: widget.fisBasligiModel,
          barcodeController: barcodeController,
          countController: countController,
          formKey: formKey,
          countFocus: countFocus,
          barcodeFocus: barcodeFocus,
        ));
    super.initState();
  }

  @override
  void dispose() {
    barcodeController.dispose();
    countController.dispose();
    countFocus.dispose();
    barcodeFocus.dispose();
    formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        NavigationService.instance.navigateToWidgetClear(
            widget: MalzemeFisleriListesiView(
                type: widget.fisBasligiModel.type,
                title:
                    "${DatabaseConstants.fisTurleri.reverseKeyValue()[widget.fisBasligiModel.type]}(${widget.fisBasligiModel.notes})"));
        return Future.value(false);
      },
      child: Scaffold(
        floatingActionButton: widget.fisBasligiModel.goldenSync == 0
            ? FloatingActionButton(
                onPressed: () {
                  ref.read(provider).addTrnLine();
                },
                child: const Icon(Icons.add),
              )
            : null,
        appBar: AppBar(
          title: Text(
              "${DatabaseConstants.fisTurleri.reverseKeyValue()[widget.fisBasligiModel.type]}(${widget.fisBasligiModel.notes})"),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.all(16.h),
          child: Form(
            child: SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Column(
                children: [..._addForm(), _itemForm()],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _addForm() {
    if (widget.fisBasligiModel.goldenSync == 0) {
      return [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: TextButton.icon(
                  label: const Text("Barkod oku"),
                  onPressed: ref.read(provider).readBarcode,
                  icon: const Icon(Icons.camera, color: Colors.black)),
            ),
            Expanded(
              child: TextButton.icon(
                  label: const Text("Listeden seç"),
                  onPressed: ref.read(provider).selectFromList,
                  icon: const Icon(Icons.search, color: Colors.black)),
            )
          ],
        ),
        Row(children: [
          Expanded(
              flex: 5,
              child: TextFormField(
                controller: barcodeController,
                onFieldSubmitted: ref.read(provider).getProductByBarcode,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    border: InputBorder.none, labelText: 'Barkod'),
              )),
          Expanded(
              flex: 1,
              child: CupertinoSwitch(
                  onChanged: (value) {
                    ref.read(provider).easyBarcode = value;
                  },
                  value: ref.watch(provider).easyBarcode))
        ]),
        Row(children: [
          Expanded(
              flex: 5,
              child: TextFormField(
                onFieldSubmitted: (value) {
                  ref.read(provider).addTrnLine();
                },
                controller: countController,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    border: InputBorder.none, labelText: 'Adet'),
              )),
          Expanded(
              flex: 1,
              child: CupertinoSwitch(
                  onChanged: (value) {
                    ref.read(provider).easyCount = value;
                  },
                  value: ref.watch(provider).easyCount))
        ]),
        Center(
            child: Text(ref.watch(provider).urunAdi,
                style: TextStyle(fontSize: 25.sp),
                textAlign: TextAlign.center)),
      ];
    } else {
      return [];
    }
  }

  ListView _itemForm() {
    return ListView.builder(
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemCount: ref.watch(provider).fisSatirlari.length,
      itemBuilder: (context, index) {
        Map<String, dynamic> urun =
            ref.watch(provider).productList!.rowByIncludeData({
          "ID": ref.watch(provider).fisSatirlari[index].productId,
          "Barcode": ref.watch(provider).fisSatirlari[index].seriNo,
        });
        String text =
            "Ürün adı: ${urun["Name"]}\nPaketteki miktarı: ${urun["Miktar"]}\nEklenen: ${ref.watch(provider).fisSatirlari[index].amount}\nBarkodu: ${urun["Barcode"]}\nAçıklaması: ${urun["Aciklama"]}";

        return Card(
          child: ListTile(
            onLongPress: widget.fisBasligiModel.goldenSync == 0
                ? () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.WARNING,
                      animType: AnimType.BOTTOMSLIDE,
                      title: 'Uyarı',
                      desc: 'Bu satırı silmek istediğinize emin misiniz?',
                      btnOkOnPress: () {
                        ref.read(provider).removeTrnLine(index);
                      },
                      btnOkIcon: Icons.delete,
                      btnOkColor: Colors.red,
                      btnOkText: 'Sil',
                      btnCancelOnPress: () {},
                      btnCancelIcon: Icons.cancel,
                      btnCancelText: 'İptal',
                    ).show();
                  }
                : null,
            onTap: widget.fisBasligiModel.goldenSync == 0
                ? () {
                    if (countController.text.isEmpty) {
                      AwesomeDialog(
                              context: context,
                              dialogType: DialogType.ERROR,
                              animType: AnimType.BOTTOMSLIDE,
                              title: 'Hata',
                              desc:
                                  'Ürünü güncellemek için adet bilgisi girmelisin.',
                              btnOkOnPress: () {},
                              btnOkIcon: Icons.check,
                              btnOkColor: Colors.red)
                          .show();
                    } else {
                      AwesomeDialog(
                          context: context,
                          title: "Ürün güncellesin mi?",
                          desc: "Değer: ${countController.text}",
                          btnCancelText: "Ekle",
                          btnOkText: "Güncelle",
                          btnOkOnPress: () {
                            ref.read(provider).updateLine(index, adding: false);
                          },
                          btnCancelOnPress: () {
                            ref.read(provider).updateLine(index, adding: true);
                          }).show();
                    }
                  }
                : null,
            subtitle: Text(text, style: TextStyle(fontSize: 15.sp)),
          ),
        );
      },
    );
  }
}
