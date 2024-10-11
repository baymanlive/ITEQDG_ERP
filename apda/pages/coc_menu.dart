import 'package:apda/pages/coc_check_qrcode.dart';
import 'package:apda/pages/coc_err_page.dart';
import 'package:apda/pages/coc_lot.dart';
import 'package:apda/utils/app_const.dart';
import 'package:apda/widgets/app_btn.dart';
import 'package:apda/widgets/app_logo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CocMenu extends StatelessWidget {
  const CocMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppLogo(),
          AppBtn(
            AppConsts.lblCocLot,
            onPressed: () => Get.to(() => CocLotPage()),
          ),
          AppBtn(
            AppConsts.lblCocCustQrcode,
            onPressed: () => Get.to(() => CocCheckQrcode()),
          ),
          AppBtn(
            AppConsts.lblCocEpt,
            onPressed: () => Get.to(() => CocErrPage()),
          ),
          AppBtn(
            AppConsts.strBack,
            onPressed: () => Get.back(),
          )
        ],
      ),
    ));
  }
}
