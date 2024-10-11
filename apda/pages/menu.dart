import 'dart:io';

import 'package:apda/pages/coc_menu.dart';
import 'package:apda/pages/tiaojiao/tjmenu.dart';
import 'package:apda/pages/zc/zc_menu.dart';
import 'package:apda/pages/zz_menu.dart';
import 'package:apda/pp_menu.dart';
import 'package:apda/title.dart';
import 'package:apda/utils/app_const.dart';
import 'package:apda/utils/global.dart';
import 'package:apda/widgets/app_btn.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            AppTitle(AppConsts.appName),
            AppBtn(
              AppConsts.btnZc,
              onPressed: Global.user['rightX'] as bool
                  ? () => Get.to(() => ZcMenu(AppConsts.btnZc))
                  : null,
            ),
            AppBtn(AppConsts.btnCoc,
                onPressed: Global.user['rightY'] as bool
                    ? () {
                        Get.to(() => CocMenu());
                      }
                    : null),
            AppBtn(AppConsts.btnZz,
                onPressed: Global.user['rightZ'] as bool
                    ? () {
                        Get.to(() => ZzMenu());
                      }
                    : null),
            AppBtn(AppConsts.btnHj),
            AppBtn(
              AppConsts.btnPp,
              onPressed: Global.user['rightE7'] as bool
                  ? () => Get.to(() => PPMenu())
                  : null,
            ),
            AppBtn(AppConsts.btnTiaojiao,
                onPressed: Global.user['rightA'] as bool
                    ? () => Get.to(() => TjMenu(AppConsts.btnTiaojiao))
                    : null),
            AppBtn(AppConsts.btnPassword),
            AppBtn(AppConsts.btnExit, onPressed: () {
              exit(0);
            }),
          ],
        ),
      ),
    );
  }
}
