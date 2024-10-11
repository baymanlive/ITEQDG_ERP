import 'package:apda/utils/global.dart';

class Qrcode {
  String bu = '';
  // String type = 'ccl';
  String id = '';
  String wono = '';
  String pno = '';
  String lot = '';
  num qty = 0;
  String rcrf = '';
  num rc = 0;
  num rf = 0;
  num gt = 0;
  String custno = '';
  String custPartDesc = '';
  String size = '';
  String custpo = '';
  String serialNo = '';
  String prodClass = '';
  String ver = '';
  String custno2 = '';
  LblType? type;
  DateTime ddate = DateTime.utc(2000, 1, 1);
  bool isNewF = false;

  String custPno = '';
  String raw = '';
  // static String old(Qrcode q) {
  //   List<String> list = [];
  //   list.add(q.wono);
  //   list.add(q.pno);
  //   list.add(q.lot);
  //   list.add(q.qty.toInt().toString());
  //   list.add(q.type == 'ccl' ? q.custPartDesc : q.rcrf);

  //   return '';
  // }

  void setQty(double value) {
    qty = value;
    var arr = raw.split(';');
    if (arr.length == 24 || arr.length == 11 || arr.length == 12) {
      arr[3] = value.toInt().toString();
      raw = arr.join(';');
    }
  }

  String oldFormat() {
    List<String> list = [];
    if (type == LblType.ccl) {
      list.add(wono);
      list.add(pno);
      list.add(lot);
      list.add(qty.toString().replaceAll('.0', ''));
      list.add(custPartDesc);
      list.add(custPno);
      list.add(rcrf);
      list.add(size);
      list.add(custpo);
      list.add(serialNo);
      list.add(prodClass);
      list.add(custno);
      list.add(id);
    } else if (type == LblType.pp) {
      list.add(wono);
      list.add(pno);
      list.add(lot);
      list.add(qty.toString().replaceAll('.0', ''));
      list.add(rcrf);
      list.add(custPartDesc);
      list.add(custPno);
      list.add(size);
      list.add(custpo);
      list.add('');
      list.add(serialNo);
      list.add(custno);
      list.add(id);
    }
    return list.join(';');
  }

  Qrcode(String str) {
    raw = str;
    var ac111Arr = str.split(String.fromCharCode(29));
    if (ac111Arr.length > 9) {
      type = LblType.tube;
      custPno = ac111Arr[1];
      qty = double.tryParse(ac111Arr[7]) ?? 0.0;
      var iteqarr = ac111Arr[10].split(';');
      pno = iteqarr[1];
      rc = double.tryParse(iteqarr[4].replaceAll('%', '')) ?? 0.0;
      lot = iteqarr[5];
      id = iteqarr[8];
    } else {
      var arr = str.split(';');
      if (arr.length == 24) {
        ver = arr[20];
        if (ver == '2') {
          isNewF = true;
        }
        id = arr[21];
        bu = 'ITEQ${id.substring(0, 2)}';

        wono = arr[0];
        pno = arr[1];
        if (arr[12] == 'CCL') {
          type = LblType.ccl;
        } else if (arr[12] == 'BS') {
          type = LblType.pp;
        } else if (arr[12] == 'PAPER_TUBE') {
          type = LblType.tube;
        }

        if (type == LblType.pp) {
          var prop = arr[5].split('/');
          if (prop.length > 2) {
            rc = double.tryParse(prop[0]) ?? 0.0;
            rf = double.tryParse(prop[1]) ?? 0.0;
            gt = double.tryParse(prop[2]) ?? 0.0;
          }
        }
        lot = arr[2];
        qty = double.tryParse(arr[3]) ?? 0.0;
        prodClass = arr[4];
        rcrf = arr[5];

        custPno = arr[6];
        custPartDesc = arr[7];
        size = arr[8].replaceAll('inch', '');
        custpo = arr[9];
        custno = arr[14];
        custno2 = arr[13];
        serialNo = arr[10];
      } else if (arr.length == 8 && arr[6] == '2') {
        type = LblType.oldTube;
        pno = arr[0];
        rc = double.tryParse(arr[3].replaceAll('%', '')) ?? 0.0;
        lot = arr[4];
        id = arr[7];
      } else if (arr.length > 10) {
        wono = arr[0];
        pno = arr[1];
        lot = arr[2];
        qty = double.tryParse(arr[3]) ?? 0.0;
        if (pno.startsWith('E') || pno.startsWith('T') || pno.startsWith('H')) {
          type = LblType.ccl;
        } else if (pno.startsWith('R') ||
            pno.startsWith('B') ||
            pno.startsWith('M') ||
            pno.startsWith('N')) {
          type = LblType.pp;
        }
        if (type == LblType.ccl) {
          custPartDesc = arr[4];
          custPno = arr[5];
          rcrf = arr[6];
          size = arr[7];
          custpo = arr[8];
          serialNo = arr[9];
          prodClass = arr[10];
          custno = arr[11];
          id = arr[12];
        } else if (type == LblType.pp) {
          rcrf = arr[4];
          var prop = rcrf.split('/');
          if (prop.length > 2) {
            rc = double.tryParse(prop[0]) ?? 0.0;
            rf = double.tryParse(prop[1]) ?? 0.0;
            gt = double.tryParse(prop[2]) ?? 0.0;
          }
          custPartDesc = arr[5];
          custPno = arr[6];
          size = arr[7];
          custpo = arr[8];
          serialNo = arr[10];
          custno = arr[11];
          id = arr[12];
        }
      }
    }
    if (wono.length == 10) {
      String y = '202${wono.substring(4, 5)}';
      String m = wono.substring(5, 6);
      if (m == 'A') {
        m = '10';
      } else if (m == 'B') {
        m = '11';
      } else if (m == 'C') {
        m = '12';
      } else {
        m = '0$m';
      }
      String d = wono.substring(6, 7);
      ddate = DateTime.utc(int.parse(y), int.parse(m), int.parse(d));
    }
  }
}
