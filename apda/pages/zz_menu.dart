import 'package:apda/ccl_bbc.dart';
import 'package:apda/pages/ccl_cgbb.dart';
import 'package:apda/pages/ccl_packing.dart';
import 'package:apda/pages/ccl_jyz_scan.dart';
import 'package:apda/utils/app_const.dart';
import 'package:apda/widgets/app_btn.dart';
import 'package:apda/widgets/app_logo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ZzMenu extends StatelessWidget {
  const ZzMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          AppLogo(),
          AppBtn(
            AppConsts.strJyzscan,
            onPressed: () => Get.to(() => CclJyzScan()),
          ),
          AppBtn(
            AppConsts.strCclPackingScan,
            onPressed: () => Get.to(() => CclPacking()),
          ),
          AppBtn(
            AppConsts.strCgbb,
            onPressed: () => Get.to(() => CclCgbb()),
          ),
          AppBtn(
            AppConsts.strBbc,
            onPressed: () => Get.to(() => CclBbc()),
          ),
        ]),
      ),
    );
  }
}
