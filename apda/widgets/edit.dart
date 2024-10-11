import 'package:apda/utils/app_size.dart';
import 'package:flutter/material.dart';

class Edit extends StatelessWidget {
  final TextEditingController controller;
  final IconData icon;
  final String hint;
  final bool obscure;
  const Edit({
    Key? key,
    required this.controller,
    required this.icon,
    required this.hint,
    this.obscure = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: AppSize.w * 10, right: AppSize.w * 10),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          blurRadius: 10,
          spreadRadius: 5,
          offset: Offset(1, 10),
          color: Colors.grey.withOpacity(0.2),
        ),
      ]),
      child: TextField(
        obscureText: obscure,
        enableSuggestions: false,
        autocorrect: false,
        controller: controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 1.0),
              borderRadius: BorderRadius.zero),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green, width: 1.0),
              borderRadius: BorderRadius.zero),
          hintText: hint,
          prefixIcon: Icon(
            icon,
            color: Colors.green[400],
          ),
        ),
      ),
    );
  }
}
