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

class PackingScan extends StatefulWidget {
  const PackingScan({super.key});

  @override
  State<PackingScan> createState() => _PackingScanState();
}

class _PackingScanState extends State<PackingScan> with ScannerMixin {
  late String _wono,
      _pno1,
      _pno2,
      _pno3,
      _lot1,
      _lot2,
      _lot3,
      _result,
      _errmsg,
      _bigcode1,
      _bigcode2,
      _arrow1;
  late bool _isWX, _scan;
  @override
  void initState() {
    super.initState();
    Global.scanner.delegate = this;
    clear();
  }

  void clear() {
    _bigcode1 = '';
    _bigcode2 = '';
    _arrow1 = '';
    _scan = false;
    setState(() {
      _wono = '';
      _pno1 = '';
      _pno2 = '';
      _pno3 = '';
      _lot1 = '';
      _lot2 = '';
      _lot3 = '';
      _isWX = false;
      _result = AppConsts.strBack;
      _errmsg = '';
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
              AppConsts.strPackingScan,
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
                children: [
                  Row(
                    children: [
                      AppText('${AppConsts.strWono}:'),
                      AppText(_wono, color: AppColor.mainColor),
                    ],
                  ),
                  Row(
                    children: [
                      AppText('${AppConsts.strPno}1:'),
                      AppText(
                        _pno1,
                        color: AppColor.mainColor,
                      )
                    ],
                  ),
                  Row(
                    children: [
                      AppText('${AppConsts.strPno}2:'),
                      AppText(
                        _pno2,
                        color: AppColor.mainColor,
                      )
                    ],
                  ),
                  if (_isWX)
                    Row(
                      children: [
                        AppText('${AppConsts.strPno}3:'),
                        AppText(
                          _pno3,
                          color: AppColor.mainColor,
                        )
                      ],
                    ),
                  Row(
                    children: [
                      AppText('${AppConsts.strLot}1:'),
                      AppText(
                        _lot1,
                        color: AppColor.mainColor,
                      )
                    ],
                  ),
                  Row(
                    children: [
                      AppText('${AppConsts.strLot}2:'),
                      AppText(
                        _lot2,
                        color: AppColor.mainColor,
                      )
                    ],
                  ),
                  if (_isWX)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText('${AppConsts.strLot}3:'),
                        AppText(
                          _lot3,
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

  @override
  Future<void> onScan(String value, Qrcode code) async {
    int diff = DateTime.now().difference(Global.packingTime).inSeconds;
    if (diff < 50) {
      Get.snackbar(AppConsts.strWrong,
          '${AppConsts.strPlsWait} $diff ${AppConsts.strSecond}');
      return;
    }
    setState(() async {
      if (code.type == LblType.pp) {
        if (_bigcode1.isEmpty) {
          _bigcode1 = value;
          _wono = code.wono;
          _pno1 = code.pno;
          _lot1 = code.lot;
          _isWX = code.custno2 == 'N006';
        } else if (Global.bu == Bu.gz) {
          _bigcode2 = value;
          _pno2 = code.pno;
          _lot2 = code.lot;
        }
      } else {
        _bigcode2 = value;
        var arr = value.split(';');
        if (arr.length > 6 && arr[6] == '2') {
          _pno2 = arr[0];
          _lot2 = arr[4];
        }
      }
      if (_isWX) {
        _scan =
            _bigcode1.isNotEmpty && _bigcode2.isNotEmpty && _arrow1.isNotEmpty;
      } else {
        _scan = _bigcode1.isNotEmpty && _bigcode2.isNotEmpty;
      }
      if (_scan) {
        if (_pno1 != _pno2) {
          _errmsg += '\n${AppConsts.strPnoDiff}'.trimLeft();
        }
        if (_lot1.substring(0, 9) != _lot2.substring(0, 9)) {
          _errmsg += '\n${AppConsts.strLotDiff}'.trimLeft();
        }
      }
    });
    if (_errmsg.isEmpty) {
      var data = {
        'str1': _bigcode1,
        'str2': _bigcode2,
        'scanner': Global.userId,
        'bu': Global.getBu(),
        'ok': 1
      };
      await AppClient.getAsync('lbl450', data);
      FlutterBeep.playSysSound(AndroidSoundIDs.TONE_PROP_ACK);
    }
  }
}
