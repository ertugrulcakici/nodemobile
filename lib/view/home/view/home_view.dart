import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/services/navigation/navigation_service.dart';
import '../../../product/constants/navigation_constants.dart';

@immutable
class HomeView extends StatefulWidget {
  final int? index;
  const HomeView({Key? key, this.index}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nodemobile'),
        centerTitle: true,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          InkWell(
            onTap: () {
              NavigationService.instance
                  .navigateToPage(path: NavigationConstants.malzemeFisleri);
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
          InkWell(
            onTap: () {
              NavigationService.instance
                  .navigateToPage(path: NavigationConstants.stoklar);
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
                      Text('Stoklar',
                          style: TextStyle(fontSize: 20.sp),
                          textAlign: TextAlign.center),
                    ]),
              ),
            ),
          )
        ],
      ),
    );
  }
}
