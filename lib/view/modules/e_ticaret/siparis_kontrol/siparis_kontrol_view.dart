import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nodemobile/view/modules/e_ticaret/siparis_kontrol/siparis_kontrol_view_model.dart';

class SiparisKontrolView extends ConsumerStatefulWidget {
  final String ficheNo;
  const SiparisKontrolView({super.key, required this.ficheNo});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SiparisKontrolViewState();
}

class _SiparisKontrolViewState extends ConsumerState<SiparisKontrolView> {
  late ChangeNotifierProvider<SiparisKontrolViewModel> provider;
  TextEditingController barcodeController = TextEditingController();
  TextEditingController countController = TextEditingController();
  FocusNode barcodeFocus = FocusNode();
  FocusNode countFocus = FocusNode();

  @override
  void initState() {
    provider = ChangeNotifierProvider((ref) => SiparisKontrolViewModel(
          barcodeController: barcodeController,
          countController: countController,
          barcodeFocus: barcodeFocus,
          countFocus: countFocus,
        ));
    Future.delayed(Duration.zero, () {
      ref.read(provider).getData(ficheNo: widget.ficheNo);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: ref.read(provider).save,
        child: const Icon(Icons.save),
      ),
      appBar: AppBar(
        title: const Text("Sipariş Kontrol"),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    if (ref.watch(provider).isLoading) {
      return _loading();
    } else {
      return _content();
    }
  }

  Widget _loading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _content() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
      child: Column(
        children: [
          _header(),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: TextButton.icon(
                      onPressed: ref.read(provider).readBarcode,
                      icon: const Icon(Icons.camera, color: Colors.black),
                      label: const Text("Barkod oku"))),
              Expanded(
                  child: TextButton.icon(
                      onPressed: ref.read(provider).selectFromList,
                      icon: const Icon(Icons.search, color: Colors.black),
                      label: const Text("Listeden seç"))),
            ],
          ),
          Row(children: [
            Expanded(
                flex: 5,
                child: TextFormField(
                  focusNode: ref.read(provider).barcodeFocus,
                  controller: ref.read(provider).barcodeController,
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
                  focusNode: ref.read(provider).countFocus,
                  onFieldSubmitted: (String value) =>
                      ref.read(provider).addProductToList(),
                  controller: ref.read(provider).countController,
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
          _productName(),
          _lines()
        ],
      ),
    );
  }

  Widget _header() {
    Map<String, dynamic> headerData = ref.watch(provider).headerData;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Müşteri: " + headerData["CustomerName"]),
        Text("Telefon: " + headerData["Phone"]),
        Text("Adres: " + headerData["Adress"]),
        Text("Fiş no: " + headerData["FicheNo"]),
        Text("Sipariş tarihi: " + headerData["OrderDate"]),
        Text("Teslimat tarihi: " + headerData["DeliveryDate"]),
        Text("Not: " + headerData["OrderNotes"]),
      ],
    );
  }

  Widget _lines() {
    List<Map<String, dynamic>> lines = ref.watch(provider).data;
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: lines.length,
        itemBuilder: (context, index) {
          return _line(lines[index]);
        },
      ),
    );
  }

  Widget _line(Map<String, dynamic> lineData) {
    num added = ref.watch(provider).addedList.containsKey(lineData["Barcode"])
        ? ref.watch(provider).addedList[lineData["Barcode"]]!
        : 0;
    return ListTile(
      title: Text(lineData["Name"]),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Birim: ${lineData["UnitCode"]}"),
          Text("Renk: ${lineData["ColorName"]}"),
          Text("Beden: ${lineData["Beden"]}"),
          Text(
              "Sipariş miktarı: ${(lineData["Amount"] as num).toStringAsFixed(2)}"),
          Text(
              "Kalan: ${((lineData["Amount"] as num) - added).toStringAsFixed(2)}"),
          Text("Not: ${lineData["Notes"]}"),
          Text("Barkod: ${lineData["Barcode"]}"),
        ],
      ),
    );
  }

  Widget _productName() {
    Map<String, dynamic>? product = ref.watch(provider).product;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
      width: double.infinity,
      child: Center(
        child: Text(
            product != null ? product["Name"] : "Ürün adı burada gözükecek"),
      ),
    );
  }
}
