import 'dart:io';

import 'package:apda/utils/app_const.dart';
import 'package:apda/utils/global.dart';
import 'package:apda/utils/qrcode.dart';
import 'package:apda/utils/scanner.dart';
import 'package:apda/widgets/app_text.dart';
import 'package:flutter/material.dart';

class CclPacking extends StatefulWidget {
  const CclPacking({super.key});

  @override
  State<CclPacking> createState() => _CclPackingState();
}

class _CclPackingState extends State<CclPacking> with ScannerMixin {
  @override
  void initState() {
    super.initState();
    Global.scanner.delegate = this;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: AppText(AppConsts.strCclPackingScan)),
    );
  }

  @override
  Future<void> onScan(String value, Qrcode code) async {
    Socket.connect('10.2.10.29', 4123).then((socket) {
      socket.listen((data) {}, onDone: () {
        socket.destroy();
      });
      socket.write(value);
    });
  }
}
