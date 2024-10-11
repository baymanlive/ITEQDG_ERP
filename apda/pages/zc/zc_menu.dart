import 'package:apda/pages/zc/zc_stock_count.dart';
import 'package:apda/title.dart';
import 'package:apda/utils/app_const.dart';
import 'package:apda/widgets/app_btn.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ZcMenu extends StatelessWidget {
  final String title;
  const ZcMenu(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Center(
        child: Column(
          children: [
            AppTitle(title),
            AppBtn(AppConsts.btnZcDeliver),
            AppBtn(AppConsts.btnZcDeliverNote),
            AppBtn(AppConsts.btnZcReceiving),
            AppBtn(AppConsts.btnZcPallet),
            AppBtn(AppConsts.btnZcAllot),
            AppBtn(AppConsts.btnZcDeliverCheck),
            AppBtn(AppConsts.btnZcJyFilesUpload),
            AppBtn(AppConsts.btnZcCoatingPrepare),
            AppBtn(AppConsts.btnZcGzAuto),
            AppBtn(
              AppConsts.btnZcStockCount,
              onPressed: () =>
                  Get.to(() => ZcStockCount(AppConsts.btnZcStockCount)),
            ),
            AppBtn(AppConsts.btnZcStkArea),
          ],
        ),
      ),
    ));
  }
}
