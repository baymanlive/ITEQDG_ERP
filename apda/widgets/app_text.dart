import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final Color? color;
  final double? size;
  const AppText(this.str, {Key? key, this.color, this.size = 18})
      : super(key: key);
  final String str;

  @override
  Widget build(BuildContext context) {
    return Text(
      str,
      style: TextStyle(fontSize: size, color: color ?? Colors.black),
    );
  }
}
