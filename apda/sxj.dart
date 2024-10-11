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

class Sxj extends StatefulWidget {
  const Sxj({super.key});

  @override
  State<Sxj> createState() => _SxjState();
}

class _SxjState extends State<Sxj> with ScannerMixin {
  late String _errmsg, _result;
  Qrcode? qr, qrTube, qrOldtube;
  @override
  void initState() {
    super.initState();
    Global.scanner.delegate = this;
    clear();
  }

  void clear() {
    setState(() {
      _result = AppConsts.strBack;
      _errmsg = '';
      qr = null;
      qrOldtube = null;
      qrTube = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            AppText(
              AppConsts.strSxjscan,
              color: AppColor.mainColor,
              size: 30,
            ),
            SizedBox(height: 10),
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
                    children: [
                      AppText('${AppConsts.strWono}:'),
                      AppText(qr?.wono ?? '', color: AppColor.mainColor),
                    ],
                  ),
                  AppText('${AppConsts.strOutBoxLabel}${AppConsts.strPno}:'),
                  AppText(
                    qr?.pno ?? '',
                    color: AppColor.mainColor,
                  ),
                  AppText('${AppConsts.strArrowLabel}${AppConsts.strPno}:'),
                  AppText(
                    qrOldtube?.pno ?? '',
                    color: AppColor.mainColor,
                  ),
                  if (isWx())
                    AppText('${AppConsts.strIteqWx}${AppConsts.strPno}:'),
                  if (isWx())
                    AppText(
                      qrTube?.pno ?? '',
                      color: AppColor.mainColor,
                    ),
                  Row(
                    children: [
                      AppText(
                          '${AppConsts.strOutBoxLabel}${AppConsts.strLot}:'),
                      AppText(
                        qr?.lot ?? '',
                        color: AppColor.mainColor,
                      )
                    ],
                  ),
                  Row(
                    children: [
                      AppText(
                          '${AppConsts.strArrowLabel}${AppConsts.strLot}:    '),
                      AppText(
                        qrOldtube?.lot ?? '',
                        color: AppColor.mainColor,
                      )
                    ],
                  ),
                  if (isWx())
                    Row(
                      children: [
                        AppText(
                            '${AppConsts.strIteqWx}${AppConsts.strLot}:        '),
                        AppText(
                          qrTube?.lot ?? '',
                          color: AppColor.mainColor,
                        )
                      ],
                    ),
                  SizedBox(height: 5),
                  if (_errmsg.isNotEmpty) AppText(_errmsg, color: Colors.red),
                ],
              ),
            ),
            Expanded(child: Container()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppBtn(
                  AppConsts.strClear,
                  width: AppSize.w * 30,
                  onPressed: (() => clear()),
                ),
                AppBtn(
                  _result,
                  width: AppSize.w * 30,
                  onPressed: () {
                    if (_result == AppConsts.strBack) {
                      Get.back();
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool isWx() {
    return qr?.custno2 == 'N006' || qrTube != null;
  }

  @override
  Future<void> onScan(String value, Qrcode code) async {
    setState(() {
      if (code.type == LblType.pp) {
        qr = code;
      } else if (code.type == LblType.tube) {
        qrTube = code;
      } else if (code.type == LblType.oldTube) {
        qrOldtube = code;
      }
    });
    if (qr != null) {
      _errmsg = '';
      if (qrOldtube != null) {
        if (qr!.custno == 'AC111' && qr!.qty != qrOldtube!.qty) {
          _errmsg += '\n${AppConsts.strQtyDiff}'.trimLeft();
        }
        if (qr?.pno != qrOldtube?.pno) {
          _errmsg += '\n${AppConsts.strPnoDiff}';
        }
        if (qr?.lot.substring(0, 9) != qrOldtube?.lot.substring(0, 9)) {
          _errmsg += '\n${AppConsts.strLotDiff}';
        }
      }
      if (isWx() && qrTube != null) {
        if (qr?.pno != qrTube?.pno) {
          _errmsg += '\n${AppConsts.strIteqWx}${AppConsts.strPoDiff}';
        }
        if (qr?.lot != qrTube?.lot) {
          _errmsg += '\n${AppConsts.strIteqWx}${AppConsts.strLotDiff}';
        }
      }
      if (_errmsg.trimLeft().isEmpty && qr != null && qrOldtube != null) {
        if (isWx() && qrTube != null) {
          await logData();
        } else if (!isWx()) {
          await logData();
        }
      }
    }
  }

  Future<void> logData() async {
    var obj = {
      'Bu': Global.getBu(),
      'userId': Global.userId,
      'Pno': qr!.pno,
      'Wono': qr!.wono,
      'Lot': qr!.lot,
      'kind': 'csft751ie'
    };
    await AppClient.getAsync('shzfile', obj, onSuccess: ((obj) {
      Get.defaultDialog(
          title: AppConsts.strOpOk, middleText: AppConsts.strTestOk);
      FlutterBeep.playSysSound(AndroidSoundIDs.TONE_PROP_ACK);
    }));
    clear();
  }
}
