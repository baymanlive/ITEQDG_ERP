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

class CclCgbb extends StatefulWidget {
  const CclCgbb({super.key});

  @override
  State<CclCgbb> createState() => _CclCgbbState();
}

class _CclCgbbState extends State<CclCgbb> with ScannerMixin {
  Qrcode oldQr = Qrcode('');
  Qrcode newQr = Qrcode('');

  @override
  void initState() {
    super.initState();
    Global.scanner.delegate = this;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
        margin: EdgeInsets.all(10),
        width: AppSize.h * 90,
        // height: AppSize.w * 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: AppSize.w * 90,
              padding:
                  EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 30),
              decoration: BoxDecoration(
                  border: Border.all(color: AppColor.mainColor, width: 1.0)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText('${AppConsts.strOld}${AppConsts.strWono}:'),
                        AppText(oldQr.wono, color: AppColor.mainColor),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText('${AppConsts.strNew}${AppConsts.strWono}:'),
                        AppText(
                          newQr.wono,
                          color: AppColor.mainColor,
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText('${AppConsts.strOld}${AppConsts.strPno}: '),
                        AppText(oldQr.pno, color: AppColor.mainColor),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText('${AppConsts.strNew}${AppConsts.strPno}:'),
                        AppText(newQr.pno, color: AppColor.mainColor),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText('${AppConsts.strOld}${AppConsts.strLot}: '),
                        AppText(oldQr.lot, color: AppColor.mainColor),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText('${AppConsts.strNew}${AppConsts.strLot}:'),
                        AppText(newQr.lot, color: AppColor.mainColor),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText('${AppConsts.strOld}${AppConsts.strQty}: '),
                        if (oldQr.qty > 0)
                          AppText(oldQr.qty.toInt().toString(),
                              color: AppColor.mainColor),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText('${AppConsts.strNew}${AppConsts.strQty}:'),
                        if (newQr.qty > 0)
                          AppText(newQr.qty.toInt().toString(),
                              color: AppColor.mainColor),
                      ],
                    ),
                  ]),
            ),
            if (hasScan())
              if (checkOk())
                Container(
                    alignment: Alignment.bottomRight,
                    child: AppBtn(AppConsts.strCheckOk, onPressed: () async {
                      bool logOk = await logData();
                      if (logOk) {
                        clear();
                      } else {
                        Get.defaultDialog(
                            title: AppConsts.strWrong,
                            middleText: AppConsts.strWriteErr);
                      }
                    }))
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
      'tb': 'LBL620',
      'userId': Global.userId,
      'p1': oldQr.wono,
      'p2': oldQr.pno,
      'p3': oldQr.lot,
      'p4': oldQr.qty.toString(),
      'p5': oldQr.rcrf,
      'p6': newQr.wono,
      'p7': newQr.pno,
      'p8': newQr.lot,
      'p9': newQr.qty.toString(),
      'p10': newQr.rcrf,
    };
    bool logOk = false;
    await AppClient.getAsync('pda_log', obj,
        onSuccess: ((obj) => logOk = true));
    if (logOk) FlutterBeep.playSysSound(AndroidSoundIDs.TONE_PROP_ACK);
    return logOk;
  }

  void clear() {
    setState(() {
      oldQr = Qrcode('');
      newQr = Qrcode('');
    });
  }

  @override
  void onScan(String value, Qrcode code) {
    setState(() {
      if (oldQr.wono.isEmpty) {
        oldQr = code;
      } else if (newQr.wono.isEmpty) {
        newQr = code;
      } else {
        newQr = code;
      }
      if (oldQr.wono.isNotEmpty && newQr.wono.isNotEmpty) {
        if (oldQr.ddate.isAfter(newQr.ddate)) {
          Qrcode tmp = newQr;
          newQr = oldQr;
          oldQr = tmp;
        }
      }
    });
  }

  bool hasScan() {
    return oldQr.wono.isNotEmpty && newQr.wono.isNotEmpty;
  }

  bool checkOk() {
    //TF010022430490AWX
    String oldPno = oldQr.pno;
    String newPno = newQr.pno;
    int lenOld = int.tryParse(oldPno.substring(8, 11)) ?? 0;
    int lenNew = int.tryParse(newPno.substring(8, 11)) ?? 0;
    if (lenNew > lenOld) return false;

    int widOld = int.tryParse(oldPno.substring(11, 14)) ?? 0;
    int widNew = int.tryParse(newPno.substring(11, 14)) ?? 0;
    if (widNew > widOld) return false;

    oldPno = oldPno.substring(1, 8) + oldPno.substring(14);
    newPno = newPno.substring(1, 8) + newPno.substring(14);
    oldPno = oldPno.substring(0, oldPno.length - 1);
    newPno = newPno.substring(0, newPno.length - 1);

    return changAd(oldPno) == changAd(newPno);
  }

  String changAd(String pno) {
    if ('WC6'.indexOf(pno.substring(0, 1)) > 0) {
      pno = 'W${pno.substring(1)}';
    } else if ('RI7'.indexOf(pno.substring(0, 1)) > 0) {
      pno = 'R${pno.substring(1)}';
    }
    return pno;
  }
}
