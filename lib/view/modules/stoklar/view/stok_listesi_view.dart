import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nodemobile/product/models/varyant_model.dart';
import 'package:nodemobile/view/modules/stoklar/viewmodel/stok_listesi_viewmodel.dart';

class StokListesiView extends ConsumerStatefulWidget {
  const StokListesiView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _StokListesiViewState();
}

class _StokListesiViewState extends ConsumerState<StokListesiView> {
  ChangeNotifierProvider<StokListesiViewModel> provider =
      ChangeNotifierProvider((ref) => StokListesiViewModel());

  @override
  void initState() {
    ref.read(provider).init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stok Listesi'), centerTitle: true),
      body: _body(),
    );
  }

  Widget _body() {
    if (ref.watch(provider).setupDone) {
      return Column(
        children: [
          const Visibility(
              visible: true,
              child: TextField(
                decoration: InputDecoration(
                    hintText: 'Ürün ara', contentPadding: EdgeInsets.all(8)),
              )),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                VaryantModel varyant = VaryantModel.fromJson(
                    ref.watch(provider).stokListesi.rowsAsJson[index]);
                return ListTile(
                  title: Text(varyant.name ?? "Ürün adı bulunamadı"),
                  subtitle: Text(
                      "Barkod: ${varyant.barcode}\nAçıklama: ${varyant.aciklama}\nMiktar: ${varyant.miktar}"),
                );
              },
            ),
          ),
        ],
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}
