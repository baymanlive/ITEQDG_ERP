import 'package:apda/pages/menu.dart';
import 'package:apda/utils/app_client.dart';
import 'package:apda/utils/app_const.dart';
import 'package:apda/utils/app_size.dart';
import 'package:apda/utils/global.dart';
import 'package:apda/widgets/app_btn.dart';
import 'package:apda/widgets/app_logo.dart';
import 'package:apda/widgets/app_text.dart';
import 'package:apda/widgets/edit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:r_upgrade/r_upgrade.dart';
// import 'package:url_launcher/url_launcher.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isLogining = false;
  bool _newVersion = false;
  bool _downloading = false;
  double? _downloadPersent = 0.0;
  var useridController = TextEditingController();
  var userPswController = TextEditingController();
  late AnimationController controller;
  final version = 30;
  @override
  void initState() {
    super.initState();
    checkUpgrade();
    // var q = Qrcode(
    //     '51F-2B1641;B6A2116560200495XC;D2B13B771B;200;56.6/33.6/126;IT158BS 2116 RC56% 200M*49.5;30601000030;49.5;5212222656;;;AC425;DG202211172001818936');
    // print(q.oldFormat());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: AppSize.h * 5,
          ),
          AppLogo(),
          SizedBox(
            height: AppSize.h * 2,
          ),
          Edit(
            controller: useridController,
            icon: Icons.login,
            hint: AppConsts.userId,
          ),
          SizedBox(
            height: AppSize.h * 2,
          ),
          Edit(
            controller: userPswController,
            icon: Icons.password,
            hint: AppConsts.userPsw,
            obscure: true,
          ),
          SizedBox(
            height: AppSize.h * 2,
          ),
          if (_downloading)
            SizedBox(
              width: 250,
              child: LinearProgressIndicator(
                value: _downloadPersent,
              ),
            ),
          AppBtn(
              _downloading ? AppConsts.strLoadingUpgrade : AppConsts.strLogin,
              onPressed: _isLogining || _downloading ? null : onLogin),
          Container(
            margin: EdgeInsets.only(right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppText('Version:${version / 100}',
                    color: Colors.grey, size: 14),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> onLogin() async {
    if (_newVersion) {
      Get.defaultDialog(
        title: AppConsts.strWrong,
        middleText: AppConsts.strToUpgrade,
      );
      await checkUpgrade();
      return;
    }
    if (useridController.text.trim().isEmpty) {
      Get.defaultDialog(
          title: AppConsts.strWrong,
          middleText: AppConsts.userId + AppConsts.strCanBeEmpty);
      return;
    }
    if (userPswController.text.trim().isEmpty) {
      Get.defaultDialog(
          title: AppConsts.strWrong,
          middleText: AppConsts.userPsw + AppConsts.strCanBeEmpty);
      return;
    }

    setState(() {
      _isLogining = true;
    });

    Global.bu = useridController.text.trim().toLowerCase().startsWith('ig')
        ? Bu.gz
        : Bu.dg;
    var loginObj = {
      'Bu': Global.getBu(),
      'UserId': useridController.text.trim(),
      'Password': userPswController.text.trim()
    };
    setState(() {
      _isLogining = true;
    });
    await AppClient.getAsync(
      'login',
      loginObj,
      onSuccess: (obj) {
        if (obj.toString() == '{}') {
          passFaild();
        } else {
          onLoginSuccess(obj);
        }
      },
    );
    setState(() {
      _isLogining = false;
    });
  }

  void onLoginSuccess(dynamic obj) {
    Global.cocNo = obj['coc_no'].toString();
    Global.userId = obj['userId'];
    Global.user = obj;
    Get.to(() => Menu());
  }

  Future<void> checkUpgrade() async {
    await AppClient.getAsync(
      'pda_version',
      {},
      onSuccess: (obj) async {
        if (obj['ver'] != version) {
          _newVersion = true;
          String url = obj['uri'];
          int? id = await RUpgrade.upgrade(url, fileName: 'app.apk');
          RUpgrade.stream.listen((DownloadInfo info) {
            _downloading = true;
            setState(() {
              _downloadPersent = info.percent! / 100;
            });
          }, onDone: () => RUpgrade.install(id!));
        }
      },
    );
  }

  void passFaild() {
    setState(() {
      Get.defaultDialog(
          title: AppConsts.strWrong, middleText: AppConsts.strUserIdPswErr);
      _isLogining = false;
    });
  }
}
