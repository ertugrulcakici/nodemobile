import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nodemobile/product/models/sevkiyat_baslik_ozet_model.dart';

class SevkiyatFisiBaslikView extends ConsumerStatefulWidget {
  final SevkiyatBaslikOzetModel baslik;
  const SevkiyatFisiBaslikView({Key? key, required this.baslik})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SevkiyatFisiBaslikViewState();
}

class _SevkiyatFisiBaslikViewState
    extends ConsumerState<SevkiyatFisiBaslikView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0.02.sw),
      child: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
                decoration: const InputDecoration(labelText: "Şoför adı")),
            TextFormField(
                decoration: const InputDecoration(labelText: "Şoför TC")),
            TextFormField(
                decoration: const InputDecoration(labelText: "Şoför Telefonu")),
            TextFormField(
                decoration: const InputDecoration(labelText: "Araç plakası")),
            TextFormField(
                decoration: const InputDecoration(labelText: "Dorse plaka")),
          ],
        ),
      ),
    );
  }
}
