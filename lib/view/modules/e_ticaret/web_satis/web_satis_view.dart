import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nodemobile/view/modules/e_ticaret/web_satis/web_satis_view_model.dart';

class WebSatisView extends ConsumerStatefulWidget {
  const WebSatisView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WebSatisViewState();
}

class _WebSatisViewState extends ConsumerState<WebSatisView> {
  ChangeNotifierProvider<WebSatisViewModel> provider =
      ChangeNotifierProvider<WebSatisViewModel>((ref) => WebSatisViewModel());

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      ref.read(provider).getHeader();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Web Satış')),
      body: _body(),
    );
  }

  Widget _body() {
    if (ref.watch(provider).isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return _content();
  }

  Widget _content() {
    List<Map<String, dynamic>> headers = ref.watch(provider).headers;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [_headers(headers), _lines()],
    );
  }

  SingleChildScrollView _headers(List<Map<String, dynamic>> headers) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(headers.length, (index) {
          Map<String, dynamic> header = headers[index];
          int code = header['Code'] as int;
          String name = header['Name'] as String;
          return InkWell(
            onTap: () {
              ref.read(provider).getProductsByCode(code);
            },
            child: Container(
              decoration: BoxDecoration(
                border: ref.watch(provider).selectedCode == code
                    ? Border.all(color: Colors.blue)
                    : null,
              ),
              margin: EdgeInsets.symmetric(horizontal: 10.w),
              child: Center(child: Text(name)),
            ),
          );
        }),
      ),
    );
  }

  Widget _lines() {
    List orders = ref.watch(provider).data[ref.watch(provider).selectedCode]!;
    if (orders.isEmpty) {
      return const Text("Boş");
    }
    log("order length: ${orders.length}");
    return SizedBox(
      height: 600.h,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: orders.length,
        itemBuilder: (context, index) {
          Map order = orders[index];
          return Text(order.toString());
        },
      ),
    );
  }
}
