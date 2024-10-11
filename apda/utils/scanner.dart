import 'package:apda/utils/app_client.dart';
import 'package:apda/utils/qrcode.dart';
import 'package:flutter/services.dart';
import 'package:sunmi_scanner/sunmi_scanner.dart';

mixin ScannerMixin {
  void onScan(String value, Qrcode code);
}

class Scanner {
  late ScannerMixin delegate;
  static const EventChannel _eventChannel = EventChannel('neo.com/app');
  late Function onScan;

  Scanner() {
    _eventChannel.receiveBroadcastStream().listen((value) async {
      var arr = value.toString().split(';');
      if (arr.length == 24 && "AC434/AC365/ACD39/AC388".contains(arr[14])) {
        arr[10] = await getSerialNo(arr[21]);
      }

      await pasreOAO06(arr);
      value = arr.join(';');
      var qrcode = Qrcode(value);
      delegate.onScan(value, qrcode);
    });
    SunmiScanner.onBarcodeScanned().listen((value) async {
      var arr = value.toString().split(';');
      if (arr.length == 24 && "AC434/AC365/ACD39/AC388".contains(arr[14])) {
        arr[10] = await getSerialNo(arr[21]);
      }

      await pasreOAO06(arr);
      value = arr.join(';');
      var qrcode = Qrcode(value);
      delegate.onScan(value, qrcode);
    });
  }

  Future<void> pasreOAO06(
    List<String> arr,
  ) async {
    if (arr.length != 24) return;
    String url =
        'http://192.168.4.14:8080/PasreOAO06.ashx?wono=${arr[0]}&bar_bu=${arr[21].substring(0, 2)}';
    String result = await AppClient.httpget(url);
    if (result == '\$\$') return;
    var ls = result.split('\$');
    if (ls.length != 3) return;

    // if (arr[1].startsWith('E') || arr[1].startsWith('T')) {
    //   arr[8] = ls[0];
    //   arr[5] = ls[1];
    //   arr[4] = ls[2];
    // } else {
    //   arr[8] = ls[0];
    //   arr[6] = ls[1];
    //   arr[5] = ls[2];
    // }
    arr[9] = ls[0];
    arr[6] = ls[1];
    arr[7] = ls[2];
  }
}

// pasreOAO06(Qrcode qrcode) async {
//   String url =
//       'http://192.168.4.14:8080/PasreOAO06.ashx?wono=${qrcode.wono}&bar_bu=${qrcode.bu.substring(4)}';
//   String result = await AppClient.httpget(url);
//   var ls = result.split('\$');

//   if (ls.length == 3) {
//     qrcode.custpo = ls[0];
//     qrcode.custPno = ls[1];
//     qrcode.custPartDesc = ls[2];
//   }
// }

Future<String> getSerialNo(String id) async {
  String no = '';
  await AppClient.getAsync(
    'fz_id',
    {'id': id},
    onSuccess: (obj) {
      if (id.startsWith('JX')) {
        no = obj.toString();
      } else if (obj.toString() == '[]') {
        no = '';
      } else {
        no = obj[0]['sno'];
      }
    },
  );
  return no;
}
