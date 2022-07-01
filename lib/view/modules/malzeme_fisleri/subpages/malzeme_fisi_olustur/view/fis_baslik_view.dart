import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nodemobile/core/services/navigation/navigation_service.dart';
import 'package:nodemobile/core/utils/extentions/map_extention.dart';
import 'package:nodemobile/core/utils/ui/popup.dart';
import 'package:nodemobile/product/constants/database_constants.dart';
import 'package:nodemobile/view/modules/malzeme_fisleri/malzeme_fisleri_view.dart';
import 'package:nodemobile/view/modules/malzeme_fisleri/subpages/malzeme_fisi_olustur/view/fis_icerik_view.dart';
import 'package:nodemobile/view/modules/malzeme_fisleri/subpages/malzeme_fisi_olustur/viewmodel/fis_baslik_viewmodel.dart';

class FisBaslikView extends ConsumerStatefulWidget {
  final int type;
  const FisBaslikView({Key? key, required this.type}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MalzemeFisiBaslikState();
}

class _MalzemeFisiBaslikState extends ConsumerState<FisBaslikView> {
  late ChangeNotifierProvider<FisBaslikViewModel> provider;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  void initState() {
    provider = ChangeNotifierProvider((ref) => FisBaslikViewModel());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        NavigationService.instance
            .navigateToWidget(widget: const MalzemeFisleriView());
        return Future.value(false);
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            _key.currentState!.save();
            if (await ref.read(provider).save(type: widget.type)) {
              PopupHelper.showSimpleSnackbar("Kaydedildi");
              NavigationService.instance.navigateToWidgetClear(
                  widget: FisIcerikView(
                      fisBasligiModel: ref.read(provider).baslik));
            } else {
              PopupHelper.showSimpleSnackbar("Kaydedilemedi");
            }
          },
          child: const Icon(Icons.save),
        ),
        appBar: AppBar(
          title:
              Text(DatabaseConstants.fisTurleri.reverseKeyValue()[widget.type]),
          centerTitle: true,
        ),
        body: Scaffold(
          body: Form(
            key: _key,
            child: Center(
                child: Padding(
              padding: EdgeInsets.all(0.025.sh),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...seciciler(),
                  TextFormField(
                    onSaved: (newValue) {
                      ref.watch<FisBaslikViewModel>(provider).baslik.ficheNo =
                          newValue ?? "";
                    },
                    decoration: const InputDecoration(
                      labelText: 'Fiş numarası',
                      hintText: 'Fiş numarası',
                    ),
                  ),
                  TextFormField(
                    onSaved: (newValue) {
                      ref.watch<FisBaslikViewModel>(provider).baslik.notes =
                          newValue ?? "";
                    },
                    decoration: const InputDecoration(
                      labelText: 'Fiş açıklaması',
                      hintText: 'Fiş açıklaması',
                    ),
                  ),
                ],
              ),
            )),
          ),
        ),
      ),
    );
  }

  TextButton _girisDepoSecici() {
    return TextButton.icon(
        onPressed: ref.read<FisBaslikViewModel>(provider).girisDeposuSec,
        icon: const Icon(Icons.edit),
        label: Text(ref.watch(provider).girisDeposuText));
  }

  TextButton _cikisDepoSecici() {
    return TextButton.icon(
        onPressed: ref.read<FisBaslikViewModel>(provider).cikisDeposuSec,
        icon: const Icon(Icons.edit),
        label: Text(ref.watch(provider).cikisDeposuText));
  }

  TextButton isYeriSecici() {
    return TextButton.icon(
        onPressed: ref.read<FisBaslikViewModel>(provider).isYeriSec,
        icon: const Icon(Icons.edit),
        label: Text(ref.watch(provider).isYeriText));
  }

  List seciciler() {
    List seciciWidgetler = [];
    if (widget.type == 2) {
      seciciWidgetler.add(_girisDepoSecici());
      seciciWidgetler.add(_cikisDepoSecici());
    } else if (widget.type == 0 || widget.type == 11 || widget.type == 14) {
      seciciWidgetler.add(_girisDepoSecici());
    } else if (widget.type == 1 || widget.type == 10) {
      seciciWidgetler.add(_cikisDepoSecici());
    }
    seciciWidgetler.add(isYeriSecici());
    return seciciWidgetler;
  }
}
