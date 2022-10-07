import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nodemobile/core/services/navigation/navigation_service.dart';
import 'package:nodemobile/core/utils/extentions/map_extention.dart';
import 'package:nodemobile/product/constants/database_constants.dart';
import 'package:nodemobile/product/constants/navigation_constants.dart';
import 'package:nodemobile/product/models/fis_baslik_model.dart';
import 'package:nodemobile/view/modules/malzeme_fisleri/subpages/malzeme_fisi_olustur/view/fis_baslik_view.dart';
import 'package:nodemobile/view/modules/malzeme_fisleri/subpages/malzeme_fisi_olustur/view/fis_icerik_view.dart';
import 'package:nodemobile/view/modules/malzeme_fisleri/subpages/malzeme_fisleri_listesi/viewmodel/malzeme_fisleri_listesi_viewmodel.dart';

// ignore: must_be_immutable
class MalzemeFisleriListesiView extends ConsumerStatefulWidget {
  final int type;

  const MalzemeFisleriListesiView({Key? key, this.type = 0}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MalzemeFisiListesiState();
}

class _MalzemeFisiListesiState
    extends ConsumerState<MalzemeFisleriListesiView> {
  late ChangeNotifierProvider<MalzemeFisleriViewModel> provider;

  @override
  void initState() {
    provider = ChangeNotifierProvider((ref) => MalzemeFisleriViewModel());
    ref.read(provider).getAllFisBasliklari(widget.type);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: _fab(), appBar: _appBar(), body: _body());
  }

  WillPopScope _body() {
    return WillPopScope(
      onWillPop: () {
        NavigationService.instance
            .navigateToPageClear(path: NavigationConstants.malzemeFisleri);
        return Future.value(false);
      },
      child: ListView.builder(
        itemCount: ref.watch(provider).basliklar.length,
        itemBuilder: (context, index) {
          FisBasligiModel item = ref.watch(provider).basliklar[index];
          List<String> info = [];
          String branchName = ref
              .watch(provider)
              .branchs
              .rowByKeyValueAsJson("BranchNo", item.branch)["Name"];
          info.add("Fiş açıklaması: ${item.notes}");
          info.add("Fiş numarası: ${item.ficheNo}");
          info.add("İş yeri: $branchName");
          info.add("Oluşturma tarihi: ${item.createdDate}");
          if (item.destStockWareHouseID != null) {
            info.add(
                "Giriş depo: ${ref.watch(provider).warehouses.rowByKeyValueAsJson("ID", item.destStockWareHouseID)["Name"]}");
          }
          if (item.stockWareHouseID != null) {
            info.add(
                "Çıkış depo: ${ref.watch(provider).warehouses.rowByKeyValueAsJson("ID", item.stockWareHouseID)["Name"]}");
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ListTile(
                trailing: item.goldenSync == 1
                    ? const Icon(Icons.check, color: Colors.green)
                    : const Icon(Icons.keyboard_arrow_right,
                        color: Colors.black),
                subtitle:
                    Text(info.join("\n"), style: TextStyle(fontSize: 16.sp)),
                onTap: () {
                  NavigationService.instance
                      .navigateToWidget(FisIcerikView(fisBasligiModel: item));
                },
                onLongPress: () {
                  if (item.goldenSync == 1) {
                    return;
                  }
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.WARNING,
                    title: "Dikkat ? ",
                    desc: "Bu işlemler geri alınamayacak!",
                    btnOkText: "Sil",
                    btnOkOnPress: () {
                      ref.read(provider).deleteFisBaslik(item);
                    },
                    btnCancelText: "Sunucuya aktar",
                    btnOkColor: const Color(0xff1bccba),
                    btnCancelColor: const Color(0xff1bccba),
                    btnCancelOnPress: () {
                      ref.read(provider).sendFisToServer(item);
                    },
                  ).show();
                },
              ),
              const Divider()
            ],
          );
        },
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text(DatabaseConstants.fisTurleri.reverseKeyValue()[widget.type]),
      centerTitle: true,
    );
  }

  FloatingActionButton _fab() {
    return FloatingActionButton(
      onPressed: () {
        NavigationService.instance
            .navigateToWidgetClear(widget: FisBaslikView(type: widget.type));
      },
      child: const Icon(Icons.add),
    );
  }
}
