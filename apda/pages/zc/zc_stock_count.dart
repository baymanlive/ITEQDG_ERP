import 'package:apda/title.dart';
import 'package:apda/utils/app_const.dart';
import 'package:apda/utils/qrcode.dart';
import 'package:apda/widgets/app_color.dart';
import 'package:apda/widgets/app_text.dart';
import 'package:flutter/material.dart';

class ZcStockCount extends StatefulWidget {
  final String title;
  const ZcStockCount(this.title, {super.key});

  @override
  State<ZcStockCount> createState() => _ZcStockCountState();
}

class _ZcStockCountState extends State<ZcStockCount> {
  List<Qrcode> list = [];
  String storageLocation = '';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Container(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          AppTitle(widget.title),
          SizedBox(height: 5),
          Expanded(
            child: Container(
              decoration:
                  BoxDecoration(border: Border.all(color: AppColor.mainColor)),
              child: Column(
                children: [
                  Row(
                    children: [
                      AppText(
                        AppConsts.strStorageLocation,
                        color: AppColor.mainColor,
                      ),
                      AppText(storageLocation),
                    ],
                  ),
                  ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(top: 5.0),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Icon(
                              Icons.backspace,
                              color: AppColor.mainColor,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    )));
  }
}
