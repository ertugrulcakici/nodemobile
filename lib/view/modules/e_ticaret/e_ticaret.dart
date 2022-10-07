import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nodemobile/core/services/navigation/navigation_service.dart';
import 'package:nodemobile/view/modules/e_ticaret/web_satis/web_satis_view.dart';

class ETicaretView extends StatefulWidget {
  const ETicaretView({super.key});

  @override
  State<ETicaretView> createState() => _ETicaretViewState();
}

class _ETicaretViewState extends State<ETicaretView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          InkWell(
            onTap: () {
              NavigationService.instance.navigateToWidget(const WebSatisView());
            },
            child: Card(
              elevation: 8,
              child: Container(
                padding: EdgeInsets.all(0.025.sh),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [Text("Web satış")],
                ),
              ),
            ),
          ),
          Card(
            elevation: 8,
            child: Container(
              padding: EdgeInsets.all(0.025.sh),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [Text("Web iade")],
              ),
            ),
          )
        ],
      ),
    );
  }
}
