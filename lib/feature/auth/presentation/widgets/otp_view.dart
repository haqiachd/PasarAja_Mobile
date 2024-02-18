import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/item_otp_view.dart';

class AuthOtpView extends StatefulWidget {
  final int? length;
  final double? boxWidth;
  const AuthOtpView({
    super.key,
    this.length = 4,
    this.boxWidth,
  });

  @override
  State<AuthOtpView> createState() => _AuthOtpViewState();
}

class _AuthOtpViewState extends State<AuthOtpView> {
  @override
  Widget build(BuildContext context) {
    return _otp(context, 6);
  }
}

class AuthOtpViews extends StatelessWidget {
  final int? length;
  final double? boxWidth;
  const AuthOtpViews({
    super.key,
    this.length = 4,
    this.boxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return _otp(context, length ?? 4);
  }
}

Widget _otp(BuildContext context, int length) {
  List<TextEditingController> controllers = List.generate(
    length,
    (index) => TextEditingController(),
  );
  List<Widget> otpWidgets = List.generate(
    length,
    (index) {
      if (index != index - 1) {
        return Row(
          children: [
            ItemOtpView(
              controller: controllers[index],
              onChanged: (pin) {
                // if (pin.isNotEmpty) {
                FocusScope.of(context).nextFocus();
                print('no');
                // }
              },
              width: 49,
              height: 49,
            ),
            const SizedBox(width: 5),
          ],
        );
      } else {
        return const ItemOtpView();
      }
    },
  );

  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: otpWidgets,
  );
}
