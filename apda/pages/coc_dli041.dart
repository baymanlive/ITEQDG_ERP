import 'package:apda/utils/app_const.dart';
import 'package:apda/utils/app_size.dart';
import 'package:apda/widgets/app_btn.dart';
import 'package:apda/widgets/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CocDli041 extends StatefulWidget {
  const CocDli041(this.list, {Key? key}) : super(key: key);
  final List list;

  @override
  State<CocDli041> createState() => _CocDli041State();
}

class _CocDli041State extends State<CocDli041> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10.0),
              width: AppSize.w * 95,
              height: AppSize.h * 80,
              decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: AppColor.mainColor)),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    children: widget.list
                        .map(
                          (e) => Text(e['QRCode']),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppBtn(
                  AppConsts.strClear,
                  width: AppSize.w * 20,
                  onPressed: () => setState(() {
                    widget.list.clear();
                  }),
                ),
                AppBtn(
                  AppConsts.strBack,
                  onPressed: Get.back,
                  width: AppSize.w * 20,
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
