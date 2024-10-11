import 'package:apda/utils/app_const.dart';
import 'package:apda/utils/app_size.dart';
import 'package:apda/widgets/app_btn.dart';
import 'package:apda/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CocZcLot extends StatelessWidget {
  final List list;

  const CocZcLot(this.list, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
      margin: EdgeInsets.all(20),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                return AppText(list[index]['manfac1'] +
                    ' / ' +
                    list[index]['qty'].toString());
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: AppBtn(
              AppConsts.strBack,
              onPressed: Get.back,
              width: AppSize.w * 20,
            ),
          ),
        ],
      ),
    )));
  }
}
