import 'package:apda/utils/app_size.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class MyLoading extends StatelessWidget {
  const MyLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: AppSize.w * 20,
        child: LoadingIndicator(
          indicatorType: Indicator.ballSpinFadeLoader,
        ),
      ),
    );
  }
}
