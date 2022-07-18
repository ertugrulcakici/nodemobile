import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nodemobile/core/services/database/database_helper.dart';

import '../../../../core/services/cache/locale_manager.dart';
import '../../../../core/services/database/database_service.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/utils/ui/popup.dart';
import '../../../../product/constants/asset_constants.dart';
import '../../../../product/constants/navigation_constants.dart';
import '../../../../product/enums/locale_manager_enums.dart';
import '../viewmodel/login_viewmodel.dart';
import 'add_firm_view.dart';
import 'edit_firm_view.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late GlobalKey<FormState> formKey;
  late ChangeNotifierProvider<LoginViewModel> provider;

  @override
  void initState() {
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();

    formKey = GlobalKey<FormState>();
    provider = ChangeNotifierProvider<LoginViewModel>((ref) => LoginViewModel(
        passwordController: _passwordController,
        usernameController: _usernameController));
    ref.read<LoginViewModel>(provider).getFirms().then((value) async {
      await DatabaseService.instance.initFirmDatabase();
      if (!value) {
        PopupHelper.showSimpleSnackbar("Firmalar getirilemedi", error: true);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    if (formKey.currentState != null) {
      formKey.currentState!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: const Text('Nodemobile El Terminali'), centerTitle: true),
        body: Stack(
          children: [
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              GestureDetector(
                  onDoubleTap: () {
                    NavigationService.instance
                        .navigateToPage(path: NavigationConstants.settings);
                  },
                  child: Image.asset(AssetConstants.logo)),
              SizedBox(height: 100.h),
              _loginForm(),
              _firmView()
            ])
          ],
        ),
      ),
    );
  }

  Container _firmView() {
    return Container(
      margin: EdgeInsets.only(top: 0.05.sh),
      constraints: BoxConstraints(maxHeight: 0.25.sh),
      child: ListView(
        shrinkWrap: true,
        children: [
          ...ref
              .watch<LoginViewModel>(provider)
              .firmList
              .reversed
              .map((model) => ListTile(
                    onTap: () async {
                      await ref
                          .read<LoginViewModel>(provider)
                          .setDefaultFirm(model);
                    },
                    tileColor:
                        ref.watch<LoginViewModel>(provider).defaultFirm?.id ==
                                model.id
                            ? const Color(0xff1bccba)
                            : Colors.transparent,
                    title: Text(model.name.isEmpty
                        ? "Firma adı girilmemiş"
                        : model.name),
                    subtitle: Text(model.serverIp.isEmpty
                        ? "Server IP girilmemiş"
                        : model.serverIp),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        NavigationService.instance.navigateToWidget(
                            widget: EditFirmView(
                          provider: provider,
                          firmModel: model,
                        ));
                      },
                    ),
                  )),
          ListTile(
            title: const Center(child: Icon(Icons.add)),
            onTap: () {
              NavigationService.instance
                  .navigateToWidget(widget: AddFirmView(provider: provider));
            },
          )
        ],
      ),
    );
  }

  SizedBox _loginForm() {
    return SizedBox(
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
            child: Consumer(
              builder: (context, ref, child) {
                return Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 16.w, right: 32.w),
                        child: TextField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            hintStyle: TextStyle(fontSize: 20),
                            border: InputBorder.none,
                            icon: Icon(Icons.account_circle_rounded),
                            hintText: "Kullanıcı adı",
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 16.w, right: 32.w),
                        child: TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(fontSize: 22.sp),
                            border: InputBorder.none,
                            icon: const Icon(Icons.lock),
                            hintText: "********",
                          ),
                        ),
                      ),
                      Row(children: [
                        Checkbox(
                            value: LocaleManager.instance
                                    .getBool(LocaleManagerEnums.rememberMe) ??
                                false,
                            onChanged: (value) {
                              setState(() {
                                LocaleManager.instance.setBool(
                                    LocaleManagerEnums.rememberMe,
                                    value ?? false);
                              });
                            }),
                        const Text("Beni hatırla")
                      ])
                    ],
                  ),
                );
              },
            ),
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
                    onTap: _login,
                    child: const Icon(
                      Icons.arrow_forward_outlined,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _login() async {
    if (await ref
        .read<LoginViewModel>(provider)
        .login(_usernameController.text, _passwordController.text)) {
      DatabaseHelper.instance.fisManager
          .setStaticLocaleFisTypes()
          .then((value) {
        NavigationService.instance
            .navigateToPageClear(path: NavigationConstants.home);
      });
    }
  }
}
