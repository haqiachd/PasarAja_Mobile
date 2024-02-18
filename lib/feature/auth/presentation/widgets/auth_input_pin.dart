import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/input_title.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/pin_view.dart';

class AuthInputPin extends StatelessWidget {
  final String? title;
  final AuthPin authPin;
  const AuthInputPin({
    super.key,
    required this.title,
    required this.authPin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 1),
          child: AuthInputTitle(title: title),
        ),
        const SizedBox(height: 12),
        authPin,
      ],
    );
  }
}
