import 'package:apda/utils/app_client.dart';
import 'package:apda/utils/app_const.dart';
import 'package:apda/utils/app_size.dart';
import 'package:apda/utils/global.dart';
import 'package:apda/utils/qrcode.dart';
import 'package:apda/utils/scanner.dart';
import 'package:apda/widgets/app_btn.dart';
import 'package:apda/widgets/app_color.dart';
import 'package:apda/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:get/get.dart';

class Data {
  String pno;
  String wono;
  Data(this.wono, this.pno);
}

class CclJyzScan extends StatefulWidget {
  const CclJyzScan({super.key});

  @override
  State<CclJyzScan> createState() => _CclJyzScanState();
}

class _CclJyzScanState extends State<CclJyzScan> with ScannerMixin {
  String wono1 = '';
  String wono2 = '';
  String pno1 = '';
  String pno2 = '';
  String lot = '';

  @override
  void initState() {
    super.initState();
    Global.scanner.delegate = this;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 20),
        margin: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                AppText(
                  AppConsts.strJyzscan,
                  color: AppColor.mainColor,
                  size: 30,
                ),
                Container(
                  height: AppSize.h * 25,
                  padding:
                      EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 5),
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: AppColor.mainColor, width: 1.0)),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText('${AppConsts.strZck}${AppConsts.strWono}:'),
                            AppText(wono1, color: AppColor.mainColor),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText(
                                '${AppConsts.strLabel}${AppConsts.strWono}:'),
                            AppText(
                              wono2,
                              color: AppColor.mainColor,
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText('${AppConsts.strZck}${AppConsts.strPno}: '),
                            AppText(pno1, color: AppColor.mainColor),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText(
                                '${AppConsts.strLabel}${AppConsts.strPno}:'),
                            AppText(pno2, color: AppColor.mainColor),
                          ],
                        ),
                      ]),
                ),
              ],
            ),
            if (hasScan())
              if (checkOk())
                AppBtn(AppConsts.strCheckOk, onPressed: () async {
                  bool logOk = await logData();
                  if (logOk) {
                    clear();
                  } else {
                    Get.defaultDialog(
                        title: AppConsts.strWrong,
                        middleText: AppConsts.strWriteErr);
                  }
                })
              else
                AppBtn(
                  AppConsts.strWrong,
                  color: Colors.red,
                  onPressed: clear,
                ),
          ],
        ),
      ),
    );
  }

  Future<bool> logData() async {
    var obj = {
      'Bu': Global.getBu(),
      'userId': Global.userId,
      'Pno': pno1,
      'Wono': wono1,
      'Lot': lot,
      'kind': 'ccljyz'
    };
    bool logOk = false;
    await AppClient.getAsync(
      'shzfile',
      obj,
      onSuccess: ((res) => logOk = true),
    );
    if (logOk) FlutterBeep.playSysSound(AndroidSoundIDs.TONE_PROP_ACK);
    return logOk;
  }

  void clear() {
    setState(() {
      pno1 = '';
      pno2 = '';
      wono1 = '';
      wono2 = '';
    });
    lot = '';
  }

  @override
  void onScan(String value, Qrcode code) {
    if (code.isNewF) {
      setState(() {
        wono2 = code.wono;
        pno2 = code.pno;
      });
      lot = code.lot;
    } else {
      var arr = value.split(';');
      if (arr.length == 2 && arr[0].length == 10) {
        setState(() {
          wono1 = arr[0];
          pno1 = arr[1];
        });
      }
    }
  }

  bool hasScan() {
    return wono1.isNotEmpty &&
        wono2.isNotEmpty &&
        pno1.isNotEmpty &&
        pno2.isNotEmpty;
  }

  bool checkOk() {
    var lpno1 = pno1;
    var lpno2 = pno2;
    if (lpno1 == lpno2) return true;
    int lenOld = int.tryParse(lpno1.substring(8, 11)) ?? 0;
    int lenNew = int.tryParse(lpno2.substring(8, 11)) ?? 0;
    if (lenNew > lenOld) return false;
    int widOld = int.tryParse(lpno1.substring(11, 14)) ?? 0;
    int widNew = int.tryParse(lpno2.substring(11, 14)) ?? 0;
    if (widNew > widOld) return false;

    lpno1 = lpno1.substring(0, 8) + lpno1.substring(14);
    lpno2 = lpno2.substring(0, 8) + lpno2.substring(14);

    return lpno1 == lpno2;
  }
}
