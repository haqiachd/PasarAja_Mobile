import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/appbar.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/pin_view.dart';

class MyTestPage extends StatefulWidget {
  const MyTestPage({super.key});

  @override
  State<MyTestPage> createState() => _MyTestPageState();
}

class _MyTestPageState extends State<MyTestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PasarAjaColor.white,
      appBar: authAppbar(),
      body: SingleChildScrollView(
        child: Center(
          child: AuthPin(
            length: 6,
            onCompleted: (value) {
              if (value == '000111') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('yes'),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
