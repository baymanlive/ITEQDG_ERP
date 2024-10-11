import 'package:apda/pages/packing_scan.dart';
import 'package:apda/sxj.dart';
import 'package:apda/utils/app_const.dart';
import 'package:apda/widgets/app_btn.dart';
import 'package:apda/widgets/app_logo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PPMenu extends StatefulWidget {
  const PPMenu({super.key});

  @override
  State<PPMenu> createState() => _PPMenuState();
}

class _PPMenuState extends State<PPMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppLogo(),
            AppBtn(
              AppConsts.strPackingScan,
              onPressed: () => Get.to(() => PackingScan()),
            ),
            AppBtn(
              AppConsts.strSxjscan,
              onPressed: () => Get.to(() => Sxj()),
            ),
          ],
        ),
      ),
    );
  }
}
