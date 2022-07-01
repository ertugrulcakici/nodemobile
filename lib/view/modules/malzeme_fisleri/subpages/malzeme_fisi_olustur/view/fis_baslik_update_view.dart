import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nodemobile/core/services/navigation/navigation_service.dart';
import 'package:nodemobile/core/utils/extentions/map_extention.dart';
import 'package:nodemobile/product/constants/database_constants.dart';
import 'package:nodemobile/product/models/fis_baslik_model.dart';
import 'package:nodemobile/view/modules/malzeme_fisleri/subpages/malzeme_fisi_olustur/viewmodel/fis_baslik_viewmodel.dart';

class FisBaslikUpdateView extends ConsumerStatefulWidget {
  final FisBasligiModel fisBasligiModel;
  const FisBaslikUpdateView({Key? key, required this.fisBasligiModel})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MalzemeFisiBaslikState();
}

class _MalzemeFisiBaslikState extends ConsumerState<FisBaslikUpdateView> {
  late ChangeNotifierProvider<FisBaslikViewModel> provider =
      ChangeNotifierProvider<FisBaslikViewModel>((ref) => FisBaslikViewModel());
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  void initState() {
    ref.read(provider).initDefaults(widget.fisBasligiModel);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _key.currentState!.save();
          if (await ref.read(provider).update()) {
            NavigationService.instance.back();
          } else {}
        },
        child: const Icon(Icons.save),
      ),
      appBar: AppBar(
        title: Text(DatabaseConstants.fisTurleri
            .reverseKeyValue()[widget.fisBasligiModel.type]),
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
                  initialValue: widget.fisBasligiModel.ficheNo,
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
                  initialValue: widget.fisBasligiModel.notes,
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
    if (widget.fisBasligiModel.type == 2) {
      seciciWidgetler.add(_girisDepoSecici());
      seciciWidgetler.add(_cikisDepoSecici());
    } else if (widget.fisBasligiModel.type == 0 ||
        widget.fisBasligiModel.type == 11 ||
        widget.fisBasligiModel.type == 14) {
      seciciWidgetler.add(_girisDepoSecici());
    } else if (widget.fisBasligiModel.type == 1 ||
        widget.fisBasligiModel.type == 10) {
      seciciWidgetler.add(_cikisDepoSecici());
    }
    seciciWidgetler.add(isYeriSecici());
    return seciciWidgetler;
  }
}
