import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import 'package:pasaraja_mobile/config/themes/lotties.dart';

class SomethingWrong extends StatelessWidget {
  const SomethingWrong({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 2,
          child: LottieBuilder.asset(
            PasarAjaLottie.somethingWrong,
          ),
        )
      ],
    );
  }
}
