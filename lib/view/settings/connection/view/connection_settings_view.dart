import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/ui/popup.dart';
import '../viewmodel/connection_settings_viewmodel.dart';

class ConnectionSettingsView extends StatefulWidget {
  const ConnectionSettingsView({Key? key}) : super(key: key);

  @override
  State<ConnectionSettingsView> createState() => _ConnectionSettingsViewState();
}

class _ConnectionSettingsViewState extends State<ConnectionSettingsView> {
  late ChangeNotifierProvider<ConnectionSettingsViewModel> provider;

  @override
  void initState() {
    provider = ChangeNotifierProvider((ref) => ConnectionSettingsViewModel());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Bağlantı ayarları'),
          centerTitle: true,
        ),
        body: Scaffold(
          body: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 150.h,
                    child: Stack(
                      children: [
                        Container(
                          height: 150.h,
                          margin: EdgeInsets.only(right: 70.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(100),
                              bottomRight: Radius.circular(100),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 0,
                                blurRadius: 10,
                                offset: Offset(0, 4.h),
                              ),
                            ],
                          ),
                          child: Consumer(builder: (context, ref, child) {
                            return Form(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: 16.w, right: 32.w),
                                    child: TextFormField(
                                      initialValue: ref
                                          .watch<ConnectionSettingsViewModel>(
                                              provider)
                                          .ip,
                                      decoration: const InputDecoration(
                                        hintStyle: TextStyle(fontSize: 20),
                                        border: InputBorder.none,
                                        icon: Icon(Icons.wifi),
                                        labelText: "Server IP",
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: 16.w, right: 32.w),
                                    child: TextFormField(
                                      initialValue: ref
                                          .watch<ConnectionSettingsViewModel>(
                                              provider)
                                          .ip,
                                      decoration: InputDecoration(
                                        hintStyle: TextStyle(fontSize: 22.sp),
                                        border: InputBorder.none,
                                        icon: const Icon(Icons.gas_meter),
                                        labelText: "Server PORT",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            margin: EdgeInsets.only(right: 15.w),
                            height: 80.h,
                            width: 80.w,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.green[200]!.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(0, 3.h),
                                ),
                              ],
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color(0xff1bccba),
                                  Color(0xff22e2ab),
                                ],
                              ),
                            ),
                            child: Consumer(
                              builder: (context, ref, child) {
                                return InkWell(
                                  onTap: () async {
                                    if (await ref.read(provider).save()) {
                                      PopupHelper.showSimpleSnackbar(
                                          "Bağlantı ayarları kaydedildi");
                                    } else {
                                      PopupHelper.showSimpleSnackbar(
                                          "Bağlantı ayarları kaydedilemedi",
                                          error: true);
                                    }
                                  },
                                  child: const Icon(
                                    Icons.save,
                                    color: Colors.white,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
