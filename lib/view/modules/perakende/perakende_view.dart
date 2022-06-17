import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/services/navigation/navigation_service.dart';
import '../../../product/constants/navigation_constants.dart';

class PerakendeView extends ConsumerStatefulWidget {
  const PerakendeView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MalzemeFisleriAnasayfaState();
}

class _MalzemeFisleriAnasayfaState extends ConsumerState<PerakendeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perakende'),
        centerTitle: true,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          InkWell(
            onTap: () {
              NavigationService.instance.navigateToPage(
                  path: NavigationConstants.malzemeFisleriListesi);
            },
            child: Card(
              elevation: 8,
              child: Container(
                padding: EdgeInsets.all(0.025.sh),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.receipt),
                      SizedBox(height: 0.01.sh),
                      Text('Malzeme fişleri',
                          style: TextStyle(fontSize: 20.sp),
                          textAlign: TextAlign.center),
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
