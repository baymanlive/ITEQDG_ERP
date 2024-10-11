import 'package:apda/utils/scanner.dart';
// import 'package:flutter_tts/flutter_tts.dart';

class Global {
  static Bu bu = Bu.dg;
  static String userId = "Test";
  static dynamic user;
  static String cocNo = '';
  static bool rightY = false; //coc
  static bool rightZ = false; //zz
  static late Scanner scanner;
  static DateTime packingTime = DateTime.now();
  static String ac111Divider = String.fromCharCode(29);
  // static late FlutterTts tts;
  static Future<void> initScanner() async {
    scanner = Scanner();

    // tts = FlutterTts();
  }

  static String getBu() {
    if (bu == Bu.dg) {
      return 'ITEQDG';
    } else if (bu == Bu.gz) {
      return 'ITEQGZ';
    } else {
      return '';
    }
  }
}

enum LblType { ccl, pp, tube, oldTube }

enum Bu { dg, gz, other }
