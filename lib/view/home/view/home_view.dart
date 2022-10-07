import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
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
    return WillPopScope(
      onWillPop: _exit,
      child: Scaffold(
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
            ),
            InkWell(
              onTap: () {
                NavigationService.instance
                    .navigateToPage(path: NavigationConstants.eTicaret);
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
                        Text('E ticaret',
                            style: TextStyle(fontSize: 20.sp),
                            textAlign: TextAlign.center),
                      ]),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<bool> _exit() async {
    AwesomeDialog(
      context: context,
      btnOkColor: Colors.red,
      btnOkText: "Çıkış yap",
      btnOkIcon: Icons.exit_to_app,
      btnOkOnPress: () {
        exit(0);
      },
      btnCancelColor: Colors.red,
      btnCancelText: "İptal",
      btnCancelIcon: Icons.cancel,
      btnCancelOnPress: () {},
      title: "Çıkış yapmak istediğinize emin misiniz?",
    ).show();
    return Future.value(false);
  }
}
