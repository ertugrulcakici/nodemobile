import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:nodemobile/product/models/sevkiyat_baslik_ozet_model.dart';
import 'package:nodemobile/view/modules/malzeme_fisleri/subpages/sevkiyat_fisi_ayrinti/view/sevkiyat_fisi_baslik_view.dart';
import 'package:nodemobile/view/modules/malzeme_fisleri/subpages/sevkiyat_fisi_ayrinti/viewmodel/sevkiyat_fisi_ayrinti_viewmodel.dart';

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
  ChangeNotifierProvider<SevkiyatFisiIcerikViewModel> provider =
      ChangeNotifierProvider((ref) => SevkiyatFisiIcerikViewModel());

  bool state = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Sevkiyat fiş no: ${widget.baslik.id}"),
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    useSafeArea: true,
                    builder: (context) {
                      return CupertinoAlertDialog(actions: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.check))
                      ], title: SevkiyatFisiBaslikView(baslik: widget.baslik));
                    },
                  );
                },
                icon: const Icon(Icons.info))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _mySelectableButton(index: 0, text: "Paket"),
                  _mySelectableButton(index: 1, text: "Palet")
                ],
              ),
              TextField(
                decoration: InputDecoration(
                    labelText: "Barkod",
                    hintText: "Barkod",
                    suffixIcon: IconButton(
                        onPressed: () {}, icon: const Icon(Icons.camera))),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 16),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 0.3)),
                  child: ListView.builder(itemBuilder: (context, index) {
                    return Slidable(
                      key: ValueKey(index.toString()),
                      groupTag: 0,
                      startActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            label: "Sil",
                            onPressed: (context) {},
                            backgroundColor: Colors.red,
                          ),
                          SlidableAction(
                            label: "Düzenle",
                            onPressed: (context) {},
                            backgroundColor: Colors.blue,
                          ),
                        ],
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Colors.grey, width: 0.3))),
                        child: ListTile(
                          title: Text("Ürün adı: ${index + 1}"),
                          subtitle: Text(
                              "Barkod: ${index + 1}\nMiktar: ${index + 1}\nYüklenen"),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _mySelectableButton({required int index, required String text}) {
    return Expanded(
      child: InkWell(
        onTap: () {
          ref.read(provider).selectableIndex = index;
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 0.04.sw),
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
          decoration: BoxDecoration(
            border: Border.all(
              color: ref.watch(provider).selectableIndex == index
                  ? Colors.blue
                  : Colors.grey,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(text),
              Visibility(
                  visible: ref.watch(provider).selectableIndex == index,
                  child: const Icon(Icons.check, color: Colors.green))
            ],
          ),
        ),
      ),
    );
  }
}
