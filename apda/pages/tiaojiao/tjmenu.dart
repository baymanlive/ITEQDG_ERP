import 'package:apda/title.dart';
import 'package:apda/utils/app_const.dart';
import 'package:apda/widgets/app_btn.dart';
import 'package:flutter/material.dart';

class TjMenu extends StatelessWidget {
  final String title;
  const TjMenu(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(children: [
          AppTitle(title),
          AppBtn(AppConsts.strIpqct620),
        ]),
      ),
    );
  }
}
