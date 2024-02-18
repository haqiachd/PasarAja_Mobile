import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/item_otp_view.dart';

class AuthOtpView extends StatefulWidget {
  final int? length;
  final double? boxWidth;
  final double? boxHeight;
  const AuthOtpView({
    super.key,
    this.length = 4,
    this.boxWidth,
    this.boxHeight,
  });

  @override
  State<AuthOtpView> createState() => _AuthOtpViewState();
}

class _AuthOtpViewState extends State<AuthOtpView> {
  @override
  Widget build(BuildContext context) {
    return _otp(context, 6, 49, 49);
  }
}

class AuthOtpViews extends StatelessWidget {
  final int? length;
  final double? boxWidth;
  final double? boxHeight;
  const AuthOtpViews({
    super.key,
    this.length = 4,
    this.boxWidth,
    this.boxHeight,
  });

  @override
  Widget build(BuildContext context) {
    return _otp(
      context,
      length ?? 4,
      boxWidth ?? 49,
      boxHeight ?? 49,
    );
  }
}

Widget _otp(
  BuildContext context,
  int length,
  double boxWidth,
  double boxHeight,
) {
  List<TextEditingController> controllers = List.generate(
    length,
    (index) => TextEditingController(),
  );

  List<Widget> otpWidgets = List.generate(
    length,
    (index) {
      return Row(
        children: [
          ItemOtpView(
            controller: controllers[index],
            width: boxWidth,
            height: boxHeight,
            obscureText: false,
            first: (index == 0),
            last: (index == length - 1),
          ),
          if (index < length - 1) const SizedBox(width: 5),
        ],
      );
    },
  );

  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: otpWidgets,
  );
}

void newMethod(BuildContext context, event) {
  if (event is RawKeyDownEvent) {
    if (event.logicalKey == LogicalKeyboardKey.backspace) {
      FocusScope.of(context).previousFocus();
    } else {
      FocusScope.of(context).nextFocus();
    }
  }
}
