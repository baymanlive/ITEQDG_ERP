import 'package:apda/pages/coc_zc_lot.dart';
import 'package:apda/utils/app_client.dart';
import 'package:apda/utils/app_const.dart';
import 'package:apda/utils/app_size.dart';
import 'package:apda/utils/global.dart';
import 'package:apda/utils/qrcode.dart';
import 'package:apda/utils/scanner.dart';
import 'package:apda/widgets/app_box.dart';
import 'package:apda/widgets/app_btn.dart';
import 'package:apda/widgets/app_color.dart';
import 'package:apda/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:get/get.dart';

class CocLotPage extends StatefulWidget {
  const CocLotPage({Key? key}) : super(key: key);

  @override
  State<CocLotPage> createState() => _CocLotPageState();
}

class _CocLotPageState extends State<CocLotPage> with ScannerMixin {
  String pno = '';
  String custPno = '';
  String custno = '';
  String lastLot = '';
  String colorDirect = '';
  String errMsg = '';
  String qty0 = '';
  String qty1 = '';
  String totalMsg = '';
  double total = 0.0;
  String dno = '';
  String ditem = '';
  List<String> list = [];
  List<Qrcode> qrList = [];
  int saveFlag = 0;
  static const saveFlagCnt = 4;
  int scanFlag = 0;
  bool isSaving = false;

  var newQtyController = TextEditingController();

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
            InfoPanel(
                pno, custno, custPno, qty0, qty1, lastLot, colorDirect, errMsg),
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
                          InkWell(
                              onTap: () {
                                newQtyController.text =
                                    qrList[index].qty.toString();
                                Get.defaultDialog(
                                    title: AppConsts.strInputQty,
                                    content: Column(
                                      children: [
                                        TextField(
                                          controller: newQtyController,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            AppBtn(
                                              AppConsts.strOk,
                                              width: 50,
                                              onPressed: () {
                                                setState(() {
                                                  qrList[index].setQty(
                                                      double.tryParse(
                                                              newQtyController
                                                                  .text) ??
                                                          0.0);
                                                  list[index] =
                                                      '${qrList[index].pno} ${qrList[index].lot} ${qrList[index].qty.toInt()}';
                                                  totalMsg = getTotal();
                                                });
                                                Get.back();
                                              },
                                            ),
                                            AppBtn(
                                              AppConsts.strCancel,
                                              width: 50,
                                              onPressed: () => Get.back(),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ));
                              },
                              child: Text(
                                list[index] +
                                    (qrList[index].type == LblType.pp
                                        ? '\n         RC:${qrList[index].rc}  RF:${qrList[index].rf}  GT:${qrList[index].gt}'
                                        : ''),
                                style:
                                    TextStyle(overflow: TextOverflow.ellipsis),
                              )),
                          SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          GestureDetector(
                            onTap: () => setState(() {
                              list.removeAt(index);
                              qrList.removeAt(index);
                              if (list.isEmpty) {
                                clear();
                              }

                              totalMsg = getTotal();
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
            SizedBox(
              height: 5.0,
            ),
            AppBox(child: AppText(totalMsg)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // AppBtn(
                //   'PO',
                //   onPressed: checkPo,
                //   width: AppSize.w * 10,
                // ),
                AppBtn(
                  '${AppConsts.strZC}${AppConsts.strLot}',
                  width: AppSize.w * 15,
                  onPressed: zcLot,
                ),
                SizedBox(width: 70.0),
                AppBtn(
                  AppConsts.strSave,
                  width: AppSize.w * 15,
                  onPressed:
                      isSaving || dno.isEmpty || ditem.isEmpty ? null : onSave,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
      pno = '';
      totalMsg = '';
      custPno = '';
      custno = '';
      lastLot = '';
      colorDirect = '';
      errMsg = '';
      qty0 = '';
      qty1 = '';
      total = 0.0;
      list.clear();
      qrList.clear();
      saveFlag = 0;
      scanFlag = 0;
      isSaving = false;
      dno = '';
      ditem = '';
    });
  }

  @override
  Future<void> onScan(value, code) async {
    if (diffPno(code.pno)) {
      Get.defaultDialog(
          title: AppConsts.strWrong, middleText: AppConsts.strPnoDiff);
      return;
    }
    qrList.add(code);
    total += code.qty;
    setState(() {
      totalMsg = getTotal();
      list.add('${code.pno} ${code.lot} ${code.qty.toInt()}');
    });

    if (list.length > 1) return;
    getColorDir(code);
    var obj = {'Bu': Global.getBu(), 'Pno': code.pno, 'Custno': code.custno};
    if (code.custno == 'AC084' || code.custno == 'ACD04') {
      String ac084msg = await checkAc084(code.wono, code.pno);
      if (ac084msg.isNotEmpty) {
        AlertDialog(
          title: Text(AppConsts.strQuesbox),
          content: Text(AppConsts.strContinue),
          actions: [
            TextButton(onPressed: () {}, child: Text(AppConsts.strYes)),
            TextButton(
                onPressed: () {
                  return;
                },
                child: Text(AppConsts.strCancel)),
          ],
        );
      }
    }
    scanFlag++;
    fetchData(obj, code);
  }

  Future<dynamic> fetchData(Map<String, String> obj, Qrcode code) async {
    return AppClient.getAsync(
      'coc_scan',
      obj,
      onSuccess: (data) async {
        var dataList = data as List;
        dynamic itm;
        scanFlag++;
        if (data.toString() == '[]') {
          Get.defaultDialog(
              title: AppConsts.strWrong, middleText: AppConsts.strDli010Empty);
          return;
        }

        if (data[0]['coc_errX']) {
          Get.snackbar(AppConsts.strWrong, AppConsts.strCocErrScan);
          return;
        }
        if (dataList.length > 1) {
          await Get.defaultDialog(
            title: AppConsts.strTip,
            middleText: AppConsts.strChoiceQty,
            barrierDismissible: false,
            onWillPop: () async => false,
            actions: dataList
                .map((e) => TextButton(
                    onPressed: () {
                      itm = e;
                      Get.back();
                    },
                    child: Text(e['Orderno'] +
                        ' ' +
                        e['Orderitem'].toString() +
                        ' ' +
                        e['Notcount'].toString())))
                .toList(),
          );
        } else {
          itm = dataList[0];
        }

        // bu = itm['Bu'];

        setState(() {
          custno = code.custno;
          pno = itm['Pno'];
          custPno = itm['Custprono'];
          dno = itm['Dno'];
          ditem = itm['Ditem'].toString();
          qty0 = itm['qty0'].toString();
          qty1 = itm['qty1'].toString();
        });
        var obj2 = {
          'Bu': Global.getBu(),
          'Pno': code.pno,
          'Exceptindate': itm['Indate'].toString().substring(0, 10),
          'Longitude': itm['Longitude'].toString(),
          'Latitude': itm['Latitude'].toString(),
          'Custno': code.custno
        };
        AppClient.getAsync(
          'coc_max_lot',
          obj2,
          onSuccess: (obj3) {
            scanFlag++;
            setState(() {
              lastLot = obj3[0]['manfac'];
            });
          },
        );
        if (list.length == 1) {
          var dli041 = {'bu': Global.getBu(), 'dno': dno, 'ditem': ditem};
          AppClient.getAsync(
            'dli041',
            dli041,
            onSuccess: (obj) {
              obj.forEach((e) {
                var code = Qrcode(e['QRCode']);
                if (code.qty > 0) {
                  //old format not valid
                  qrList.add(code);
                  list.add('${code.pno} ${code.lot} ${code.qty.toInt()}');
                }
              });
              setState(() {
                list = list;
                totalMsg = getTotal();
              });
            },
          );
        }
      },
    );
  }

  Future<String> checkAc084(String wono, String pno) async {
    String result = '';
    await AppClient.getAsync('coc_ac084_err', {'wono': wono, 'pno': pno},
        onSuccess: ((obj) {
      result = obj;
    }));
    return result;
  }

  Future<void> getColorDir(Qrcode code) async {
    var obj3 = {'Bu': Global.getBu(), 'Pno': code.pno, 'Custno': code.custno};
    await AppClient.getAsync('coc_color_dir', obj3, onSuccess: (obj) {
      scanFlag++;
      setState(() {
        colorDirect = obj.toString();
      });
    });
  }

  String getTotal() {
    total = 0;
    for (var element in qrList) {
      total += element.qty;
    }
    String msg = total.toString();
    if (pno.startsWith('E') || pno.startsWith('T')) {
      if (pno.length == 18) {
        double? diveder = double.tryParse(pno.substring(10, 3));
        if (diveder != null) msg += ' / $diveder';
      }
    }
    return msg;
  }

  Future<String> checkPo() async {
    var obj2 = {
      'Bu': Global.getBu(),
      'Dno': dno,
      'ditem': ditem,
      'pno': pno,
      'c': custno
    };
    String result = '';
    await AppClient.getAsync('check_qrcode', obj2, onSuccess: (obj) {
      result = obj.toString().replaceAll('[', '').replaceAll(']', '');
      if (result.isEmpty) {
        result = AppConsts.strTestOk;
      }
    });
    return result;
  }

  Future<void> zcLot() async {
    var obj = {'bu': Global.getBu(), 'dno': dno, 'ditem': ditem};
    await AppClient.getAsync(
      'coc_zc_lot',
      obj,
      onSuccess: (obj) {
        var list = obj as List;
        list = list.where((element) => element['jflag'] == 0).toList();
        Get.to(() => CocZcLot(list));
      },
    );
  }

  Future<void> onSave() async {
    if (qrList.map((e) => e.pno).toList().toSet().length > 1) {
      Get.defaultDialog(
          title: AppConsts.strWrong, middleText: AppConsts.strPnoDiff);
      return;
    }
    int sno;
    setState(() {
      isSaving = true;
    });
    sno = 1;
    var data = qrList
        .map((e) => {
              'bu': Global.getBu(),
              'dno': dno,
              'ditem': ditem,
              'sno': sno++,
              'manfac': e.lot,
              'qty': e.qty,
              'rc': e.rc,
              'rf': e.rf,
              'pg': e.gt
            })
        .toList();
    AppClient.getAsync('update_dli040', data, onSuccess: (obj) {
      var coccount = {'bu': Global.getBu(), 'dno': dno, 'ditem': ditem};
      AppClient.getAsync('update_coccount', coccount,
          onSuccess: (obj) => saveOk());
      saveOk();
    });
    sno = 1;
    var data41 = qrList
        .map((e) => {
              'bu': Global.getBu(),
              'dno': dno,
              'ditem': ditem,
              'sno': sno++,
              // 'fname1': e.wono,
              // 'fname2': e.pno,
              // 'fname3': e.lot,
              // 'fname4': e.qty.toInt().toString(),
              // 'fname5': e.type == 'pp' ? e.rcrf : e.custPartDesc,
              // 'fname6': e.type == 'pp' ? e.custPartDesc : e.custPno,
              // 'fname7': e.type == 'pp' ? e.custPno : e.rcrf,
              // 'fname8': e.size,
              // 'fname9': e.custpo,
              // 'fname10': e.type == 'pp' ? '' : e.serialNo,
              // 'fname11': e.type == 'pp' ? e.serialNo : e.prodClass,
              // 'fname12': e.type == 'pp' ? '' : e.custno,
              'custno': e.custno,
              'qrcode': e.oldFormat() //  e.raw
            })
        .toList();
    AppClient.getAsync('update_dli041', data41, onSuccess: (obj) => saveOk());

    var cocNo = {
      'bu': Global.getBu(),
      'dno': dno,
      'ditem': ditem,
      'coc_user': Global.userId,
      'coc_no': Global.cocNo,
      'userid': Global.userId
    };
    AppClient.getAsync('update_cocno', cocNo, onSuccess: (obj) => saveOk());
  }

  Future<void> saveOk() async {
    saveFlag++;
    if (saveFlag == saveFlagCnt && errMsg.isEmpty) {
      var result = await checkPo();
      FlutterBeep.playSysSound(AndroidSoundIDs.TONE_PROP_ACK);
      Get.defaultDialog(
        title: AppConsts.strTip,
        middleText: '${AppConsts.strSaveOk}\n$result',
      );
      // checkPo();
      clear();
    }
  }

  bool diffPno(String inputPno) {
    if (pno.isEmpty) return false;
    return inputPno != pno;
  }
}

class InfoPanel extends StatelessWidget {
  const InfoPanel(
    this.pno,
    this.custno,
    this.custPno,
    this.qty0,
    this.qty1,
    this.lastLot,
    this.colorDirect,
    this.errMsg, {
    Key? key,
  }) : super(key: key);

  final String pno;
  final String custno;
  final String custPno;
  final String qty0;
  final String qty1;
  final String lastLot;
  final String colorDirect;
  final String errMsg;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSize.w * 90,
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 30),
      decoration: BoxDecoration(
          border: Border.all(color: AppColor.mainColor, width: 1.0)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        AppText('${AppConsts.strCustno}: $custno'),
        AppText('${AppConsts.strPno}: $pno'),
        AppText('${AppConsts.strCustPno}: $custPno'),
        AppText('${AppConsts.strOrderCount}: $qty0'),
        AppText('${AppConsts.strNotCount}: $qty1'),
        AppText('${AppConsts.strLastLot}: $lastLot'),
        AppText('${AppConsts.strColorDirect}: $colorDirect'),
        if (errMsg.isNotEmpty)
          AppText(
            '${AppConsts.strErrMsg}: $errMsg',
            color: Colors.red,
          ),
      ]),
    );
  }
}
