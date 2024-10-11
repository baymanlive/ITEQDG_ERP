import 'package:apda/utils/app_size.dart';
import 'package:apda/widgets/app_color.dart';
import 'package:flutter/material.dart';

class AppBox extends StatelessWidget {
  final Widget child;
  const AppBox({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSize.w * 90,
      padding: EdgeInsets.all(2.0),
      decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: AppColor.mainColor)),
      child: child,
    );
  }
}
