import 'package:apda/utils/app_size.dart';
import 'package:apda/widgets/app_color.dart';
import 'package:apda/widgets/app_text.dart';
import 'package:flutter/cupertino.dart';

class AppTitle extends StatelessWidget {
  final String title;
  const AppTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/logo.png',
          width: AppSize.w * 30,
        ),
        SizedBox(
          width: 10,
        ),
        AppText(title, size: 30, color: AppColor.mainColor),
      ],
    );
  }
}
