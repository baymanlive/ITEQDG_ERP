import 'package:apda/widgets/app_color.dart';
import 'package:flutter/material.dart';

class AppBtn extends StatelessWidget {
  final String text;
  final double width;
  final VoidCallback? onPressed;
  final Color color;
  const AppBtn(
    this.text, {
    Key? key,
    this.onPressed,
    this.width = 250,
    this.color = AppColor.mainColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 2),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          // primary: AppColor.mainColor,
          minimumSize: Size(width, 40),
        ),
        child: Text(text),
      ),
    );
  }
}
