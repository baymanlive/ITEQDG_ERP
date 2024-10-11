import 'dart:convert';

import 'package:apda/utils/app_const.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';

class AppClient {
  static getAsync(
    String path,
    Object obj, {
    Function()? onFail,
    Function()? onFinal,
    void Function(dynamic obj)? onSuccess,
  }) async {
    // try {
    var url = Uri.parse(AppConsts.baseUrl + path);
    var res = await post(
      url,
      body: json.encode(obj),
      headers: {"Content-Type": "application/json"},
    );
    dynamic result = '{}';
    if (res.body.isNotEmpty) {
      result = jsonDecode(res.body);
    }

    if (res.statusCode == 200) {
      if (onSuccess != null) {
        onSuccess(result);
      }
      return;
    } else {
      Get.snackbar(AppConsts.strWrong, res.body);
      await Future.delayed(Duration(seconds: 2));
      if (onFail != null) {
        onFail;
      }
    }
    // }
    //  catch (e) {
    //   Get.defaultDialog(
    //       title: AppConsts.strWrong, middleText: '$path\n${e.toString()}');
    // }
  }

  static httpget(String fullUrl) async {
    var result = await get(Uri.parse(fullUrl));
    return result.body;
  }
}
