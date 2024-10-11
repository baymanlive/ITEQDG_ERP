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

class CocCheckQrcode extends StatefulWidget {
  const CocCheckQrcode({Key? key}) : super(key: key);

  @override
  State<CocCheckQrcode> createState() => _CocCheckQrcodeState();
}

class _CocCheckQrcodeState extends State<CocCheckQrcode> with ScannerMixin {
  bool isSaving = false;
  String custno = '';
  String pallet = '';
  String pno = '';
  String splitter = '';
  num total = 0;
  dynamic dli640;
  List<String> arr = [];
  List<String> list = [];
  List<Qrcode> qrList = [];
  bool checking = false;
  bool isccl = false;
  bool checkQty = false;
  @override
  void initState() {
    super.initState();
    Global.scanner.delegate = this;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        margin: EdgeInsets.all(10.0),
        child: Column(
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
                        AppText('${AppConsts.strCustno}: $custno'),
                        AppText('${list.length} ${AppConsts.strRecord}')
                      ],
                    ),
                    AppText('${AppConsts.strTotalQty}: ${total.toString()}'),
                    AppText(
                        '${AppConsts.strScannedTotalQty}: ${getScannedTotal()}'),
                    AppText('${AppConsts.strPallet}: $pallet'),
                  ]),
            ),
            SizedBox(height: 10.0),
            Expanded(
              child: Container(
                width: AppSize.w * 90,
                decoration: BoxDecoration(
                    border: Border.all(color: AppColor.mainColor)),
                child: ListView.builder(
                  // shrinkWrap: true,
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(top: 5.0),
                      child: Row(
                        children: [
                          Text(
                            list[index],
                            style: TextStyle(overflow: TextOverflow.ellipsis),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () => setState(() {
                              list.removeAt(index);
                              qrList.removeAt(index);
                              if (list.isEmpty) {
                                clear();
                              }
                            }),
                            child: Icon(
                              Icons.backspace,
                              color: AppColor.mainColor,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppBtn(
                  AppConsts.strSave,
                  onPressed: isSaving ? null : onSave,
                  width: AppSize.w * 30,
                ),
                AppBtn(
                  AppConsts.strClear,
                  onPressed: clear,
                  width: AppSize.w * 30,
                ),
                AppBtn(
                  AppConsts.strBack,
                  onPressed: () => Get.back(),
                  width: AppSize.w * 30,
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }

  void clear() {
    setState(() {
      dli640 = null;
      list.clear();
      qrList.clear();
      custno = '';
      pallet = '';
      total = 0;
      isSaving = false;
    });
  }

  @override
  Future<void> onScan(value, code) async {
    if (pallet.isEmpty) {
      setState(() {
        if (code.isNewF) {
          pallet = code.oldFormat();
          custno = code.custno;
          pno = code.pno;
          total = code.qty;
        } else {
          pallet = value;
        }
      });
      await getDLI640(custno, code.type == LblType.ccl);
    } else {
      isccl = code.type == LblType.ccl;
      if (custno.isEmpty) {
        pno = code.pno;
        setState(() {
          custno = code.custno;
        });
      }
      if (list.length > 1) {
        if (custno != code.custno) {
          Get.defaultDialog(
              title: AppConsts.strWrong,
              middleText: AppConsts.strCustnoNotMarch);
          return;
        } else if (pno != code.pno) {
          Get.defaultDialog(
              title: AppConsts.strWrong, middleText: AppConsts.strPnoDiff);
          return;
        }
      }

      await getDLI640(code.custno, code.type == LblType.ccl);
      List<String> errmsg = [];
      errmsg.add(checkField('pno', code.pno, AppConsts.strPnoDiff));
      errmsg.add(checkField('lot', code.lot, AppConsts.strLotDiff));
      errmsg
          .add(checkField('po', code.custpo, AppConsts.strCustPoDiff)); //客戶訂單號
      // errmsg.add(checkField('qty', code.custpo, AppConsts.strQtyDiff));
      errmsg = errmsg.where((element) => element.isNotEmpty).toList();
      if (errmsg.isNotEmpty) {
        showMsg(errmsg.join('\n').trim());
        return;
      }

      qrList.add(code);
      setState(() {
        list.add('${code.pno} ${code.lot} ${code.qty.toInt()}');
      });
    }
  }

  String checkField(String fn, String value, String msg) {
    int pos, fst, lst;
    String kbValue;
    checkQty = dli640['qty_chk'] == 1;
    fst = dli640['qty_fst'];
    lst = dli640['qty_lst'];
    if (checkQty && total == 0.0) {
      pos = dli640['qty'] - 1;
      if (arr.length < pos || pos < 0) {
        return AppConsts.strParamPosErr;
      } else {
        kbValue = arr[pos];
        if (lst > 0 && kbValue.length >= lst) {
          kbValue = kbValue.substring(0, kbValue.length - lst);
        }
        if (fst > 0 && kbValue.length >= fst) {
          kbValue = kbValue.substring(fst);
        }
        setState(() {
          total = int.tryParse(kbValue) ?? 0;
        });
      }
    }
    if (dli640['${fn}_chk'] == 1) {
      pos = dli640[fn] - 1;
      fst = dli640['${fn}_fst'];
      lst = dli640['${fn}_lst'];

      if (arr.length < pos || pos < 0) {
        return AppConsts.strParamPosErr;
      } else {
        kbValue = arr[pos];
        if (lst > 0 && kbValue.length >= lst) {
          kbValue = kbValue.substring(0, kbValue.length - lst);
        }
        if (fst > 0 && kbValue.length >= fst) {
          kbValue = kbValue.substring(fst);
        }
        if (kbValue != value) {
          return msg;
        } else {
          return '';
        }
      }
    } else {
      return '';
    }
  }

  // void check() {
  //   var obj = {'bu': Global.bu, 'custno': custno, 'isccl': isccl};

  //   AppClient.getAsync('dli640', obj, onSuccess: ((obj) {
  //     if (obj.toString() == '[]') {
  //       Get.defaultDialog(
  //           title: AppConsts.strWrong, middleText: AppConsts.strNoParam);
  //     }
  //     obj = obj[0];
  //     String splitrer = obj['splitrer'];
  //     if (splitrer.isEmpty) {
  //       showMsg(AppConsts.strNoSplitrer);
  //       return;
  //     }
  //     var arr = pallet.split(splitrer);
  //     int pos = -1;
  //     for (var e in qrList) {
  //       {
  //         //check pno
  //         if (obj['pno_chk'] == '1') {
  //           pos = obj['pno'];
  //         }
  //         if (arr.length < pos || pos < 0) {
  //           showMsg(AppConsts.strParamPosErr);
  //           return;
  //         }
  //         if (arr[pos] != e.custPno) {
  //           showMsg(AppConsts.strPnoDiff);
  //           return;
  //         }
  //       }
  //       {
  //         //check lot
  //         if (obj['lot_chk'] == '1') {
  //           pos = obj['lot'];
  //         }
  //         if (arr.length < pos || pos < 0) {
  //           showMsg(AppConsts.strParamPosErr);
  //           return;
  //         }
  //         print(pos);
  //         print(arr[pos]);
  //         print(e.lot);
  //         if (arr[pos] != e.lot) {
  //           showMsg(AppConsts.strLotDiff);
  //           return;
  //         }
  //       }
  //       {
  //         //check custpo
  //         if (obj['po_chk'] == '1') {
  //           pos = obj['cpo'];
  //         }
  //         if (arr.length < pos || pos < 0) {
  //           showMsg(AppConsts.strParamPosErr);
  //           return;
  //         }
  //         print(pos);
  //         print(arr[pos]);
  //         print(e.custpo);
  //         if (arr[pos] != e.custpo) {
  //           showMsg(AppConsts.strCustPoDiff);
  //           return;
  //         }
  //       }
  //     }
  //   }));
  // }

  Future<void> getDLI640(String custno, bool isccl) async {
    if (dli640 == null && custno.isNotEmpty) {
      var data = {'bu': Global.getBu(), 'custno': custno, 'isccl': isccl};
      await AppClient.getAsync('dli640', data, onSuccess: ((result) {
        dli640 = result[0];
      }));

      if (dli640 == null) {
        Get.defaultDialog(
            title: AppConsts.strWrong,
            middleText: custno + AppConsts.strNoParam);
        return;
      }
      splitter = dli640['splitter'];
      if (splitter.isEmpty) {
        showMsg(AppConsts.strNoSplitrer);
        return;
      }
      arr = pallet.split(splitter);
    }
  }

  void showMsg(String msg) {
    Get.defaultDialog(title: AppConsts.strWrong, middleText: msg);
  }

  Future<void> onSave() async {
    if (checkQty && total != getScannedTotal()) {
      Get.defaultDialog(
          title: AppConsts.strWrong, middleText: AppConsts.strQtyDiff);
      return;
    }
    setState(() {
      isSaving = true;
    });
    var data = qrList
        .map((e) => {
              'bu': Global.getBu(),
              'custno': custno,
              'Iuser': Global.userId,
              'qrcode1': pallet,
              'qrcode2': e.raw,
            })
        .toList();
    await AppClient.getAsync('insert_dli641', data, onSuccess: ((obj) {
      Get.defaultDialog(
        title: AppConsts.strTip,
        middleText: AppConsts.strOpOk,
      );
      clear();
      FlutterBeep.playSysSound(AndroidSoundIDs.TONE_PROP_ACK);
    }));
  }

  num getScannedTotal() {
    if (qrList.isEmpty) return 0;
    return qrList
        .map((e) => e.qty)
        .reduce((value, element) => value + element)
        .toInt();
  }
}
