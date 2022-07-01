import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nodemobile/core/utils/extentions/map_extention.dart';
import 'package:nodemobile/product/constants/database_constants.dart';
import 'package:nodemobile/view/modules/malzeme_fisleri/subpages/malzeme_fisleri_listesi/view/malzeme_fisleri_listesi.dart';

import '../../../core/services/navigation/navigation_service.dart';
import '../../../product/constants/navigation_constants.dart';

class MalzemeFisleriView extends ConsumerStatefulWidget {
  const MalzemeFisleriView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MalzemeFisleriAnasayfaState();
}

class _MalzemeFisleriAnasayfaState extends ConsumerState<MalzemeFisleriView> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        NavigationService.instance
            .navigateToPageClear(path: NavigationConstants.home);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Malzeme fişleri'),
          centerTitle: true,
        ),
        body: GridView.count(
          crossAxisCount: 2,
          children: [
            ...List.generate(
                DatabaseConstants.fisTurleri.length,
                (index) => InkWell(
                      onTap: () {
                        NavigationService.instance.navigateToWidget(
                            widget: MalzemeFisleriListesiView(
                                type: DatabaseConstants.fisTurleri
                                    .toList()[index][1]));
                      },
                      child: Card(
                        elevation: 8,
                        child: Container(
                          padding: EdgeInsets.all(0.025.sh),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              DatabaseConstants.fisIconlari.toList()[index][1],
                              SizedBox(height: 0.01.sh),
                              Text(DatabaseConstants.fisTurleri.toList()[index]
                                  [0])
                            ],
                          ),
                        ),
                      ),
                    )),
            InkWell(
              onTap: () {
                NavigationService.instance.navigateToPage(
                    path: NavigationConstants.sevkiyatFisleriListesi);
              },
              child: Card(
                elevation: 8,
                child: Container(
                  padding: EdgeInsets.all(0.025.sh),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.shop),
                      SizedBox(height: 0.01.sh),
                      const Text("Sevkiyat fişleri")
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
