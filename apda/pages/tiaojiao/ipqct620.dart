import 'package:apda/title.dart';
import 'package:apda/utils/app_const.dart';
import 'package:flutter/material.dart';

class Ipqct620 extends StatefulWidget {
  const Ipqct620({super.key});

  @override
  State<Ipqct620> createState() => _Ipqct620State();
}

class _Ipqct620State extends State<Ipqct620> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Row(
        children: [
          AppTitle(AppConsts.strIpqct620),
        ],
      )),
    );
  }
}
