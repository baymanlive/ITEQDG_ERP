import 'package:apda/utils/app_const.dart';
import 'package:apda/utils/app_size.dart';
import 'package:apda/utils/global.dart';
import 'package:apda/utils/qrcode.dart';
import 'package:apda/utils/scanner.dart';
import 'package:apda/widgets/app_btn.dart';
import 'package:apda/widgets/app_color.dart';
import 'package:apda/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CclBbc extends StatefulWidget {
  const CclBbc({super.key});

  @override
  State<CclBbc> createState() => _CclBbcState();
}

class _CclBbcState extends State<CclBbc> with ScannerMixin {
  @override
  void initState() {
    super.initState();
    Global.scanner.delegate = this;
  }

  List<String> list = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Center(
        child: Column(
          children: [
            Container(
              width: AppSize.w * 90,
              height: AppSize.h * 80,
              margin: EdgeInsets.all(10),
              decoration:
                  BoxDecoration(border: Border.all(color: AppColor.mainColor)),
              child: list.isEmpty
                  ? Container()
                  : Container(
                      padding: EdgeInsets.only(left: 10),
                      child: ListView.builder(
                        // shrinkWrap: true,
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          return Row(children: [
                            (list[0].substring(1) == list[index].substring(1))
                                ? AppText(list[index],
                                    color: AppColor.mainColor)
                                : AppText(list[index], color: Colors.red),
                          ]);
                        },
                      ),
                    ),
            ),
            AppBtn(
              AppConsts.strClear,
              onPressed: list.isEmpty
                  ? null
                  : () => setState(() {
                        list.clear();
                      }),
            ),
          ],
        ),
      ),
    ));
  }

  @override
  void onScan(String value, Qrcode code) {
    if (list.length > 1 && list[0].substring(1) != code.pno.substring(1)) {
      Get.defaultDialog(
          title: AppConsts.strWrong, middleText: AppConsts.strPnoDiff);
    }
    if (code.pno.isNotEmpty) {
      setState(() {
        list.add(code.pno);
      });
    }
  }
}
