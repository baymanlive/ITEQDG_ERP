import 'package:apda/utils/app_client.dart';
import 'package:apda/utils/app_const.dart';
import 'package:apda/utils/app_size.dart';
import 'package:apda/utils/global.dart';
import 'package:apda/widgets/app_btn.dart';
import 'package:apda/widgets/app_color.dart';
import 'package:apda/widgets/bu.dart';
import 'package:apda/widgets/my_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CocErrRemarkPage extends StatefulWidget {
  final OrderModel obj;
  const CocErrRemarkPage(this.obj, {Key? key}) : super(key: key);

  @override
  State<CocErrRemarkPage> createState() => _CocErrRemarkPageState();
}

class _CocErrRemarkPageState extends State<CocErrRemarkPage> {
  late List<CocErrReason> _reasons;
  bool _loading = true;
  @override
  initState() {
    super.initState();
    _reasons = AppConsts.errReasons.map(
      (e) {
        int i = 0;
        return CocErrReason(i, e);
      },
    ).toList();
    loadData();
  }

  loadData() async {
    var obj = {
      'bu': widget.obj.bu,
      'dno': widget.obj.dno,
      'ditem': widget.obj.ditem
    };
    String detail = '';
    await AppClient.getAsync(
      'coc_err',
      obj,
      onSuccess: (str) => detail = str[0]['coc_errid'],
    );

    // String detail = results['value'][0]['coc_errid'];
    var ls = detail.split(',');
    setState(() {
      for (int i = 0; i < ls.length - 1; i++) {
        _reasons[int.parse(ls[i])].checked = true;
      }
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _loading
            ? MyLoading()
            : Column(
                children: [
                  SizedBox(
                    height: AppSize.h * 4,
                  ),
                  Container(
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        border:
                            Border.all(width: 1, color: AppColor.mainColor)),
                    child: Column(
                      children: _reasons
                          .map((e) => Row(
                                children: [
                                  Checkbox(
                                      value: e.checked,
                                      onChanged: (value) => setState(() {
                                            e.checked = value ?? false;
                                          })),
                                  Text(e.reason),
                                ],
                              ))
                          .toList(),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppBtn(
                            AppConsts.strOk,
                            width: AppSize.w * 20,
                            onPressed: updateErrid
                            //  () {
                            //   _reasons.where((element) => element.checked).isNotEmpty
                            //       ? updateErrid()
                            //       : Get.snackbar(
                            //           AppConsts.strWrong, AppConsts.strAtleastOne,
                            //           backgroundColor: AppColor.mainColor,
                            //           colorText: Colors.white);
                            // }
                            ,
                          ),
                          AppBtn(
                            AppConsts.strBack,
                            width: AppSize.w * 20,
                            onPressed: () => Get.back(),
                          ),
                        ]),
                  ),
                ],
              ));
  }

  Future<void> updateErrid() async {
    String id = "";
    for (int i = 0; i < _reasons.length; i++) {
      if (_reasons[i].checked) {
        id += "$i,";
      }
    }
    var updateObj = {
      'Bu': widget.obj.bu,
      'UserId': Global.userId,
      'Dno': widget.obj.dno,
      'Ditem': widget.obj.ditem,
      'ErrId': id
    };
    var result = await AppClient.getAsync('update_coc_errid', updateObj);
    if (result['statusCode'] == 200) {
      Get.snackbar(AppConsts.strTip, AppConsts.strOpOk,
          backgroundColor: AppColor.mainColor, colorText: Colors.white);
    }
  }
}

class CocErrReason {
  final int idx;
  final String reason;
  bool checked = false;

  CocErrReason(this.idx, this.reason);
}
