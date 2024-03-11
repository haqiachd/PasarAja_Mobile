import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/images.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/module/auth/providers/verify/verify_pin_provider.dart';
import 'package:pasaraja_mobile/module/auth/widgets/widgets.dart';
import 'package:provider/provider.dart';

class VerifyPinPage extends StatefulWidget {
  final String phone;
  const VerifyPinPage({
    super.key,
    required this.phone,
  });

  @override
  State<VerifyPinPage> createState() => _VerifyPinPageState();
}

class _VerifyPinPageState extends State<VerifyPinPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<VerifyPinProvider>(context, listen: false).resetData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PasarAjaColor.white,
      appBar: authAppbar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: 19,
            right: 19,
            top: 176 -
                (MediaQuery.of(context).padding.top +
                    PasarAjaConstant.authTolbarHeight),
          ),
          child: Column(
            children: [
              const AuthInit(
                image: PasarAjaImage.ilInputPin,
                title: 'Masukan PIN',
                description:
                    'Silakan masukkan PIN Anda untuk memverifikasi identitas Anda.',
              ),
              const SizedBox(height: 19),
              Padding(
                padding: const EdgeInsets.only(left: 0, right: 0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: _buildInputPin(),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: _buildHelperMessage(),
              ),
              const SizedBox(height: 40),
              Visibility(
                visible: false,
                child: _buildButton(),
              ),
              _buildButtonLupaPin(),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Message
  _buildHelperMessage() {
    return Consumer<VerifyPinProvider>(
      builder: (context, provider, child) {
        return AuthHelperText(
          title: provider.message.toString(),
        );
      },
    );
  }

  // Input PIN
  _buildInputPin() {
    return Consumer<VerifyPinProvider>(
      builder: (context, provider, child) {
        return AuthInputPin(
          title: 'Masukan PIN',
          authPin: AuthPin(
            length: 6,
            onChanged: (value) {
              provider.message = '';
            },
            onCompleted: (value) async {
              //
              provider.onCompletePin(
                phone: widget.phone,
                pin: value,
              );
            },
          ),
        );
      },
    );
  }

  _buildButton() {
    return Consumer<VerifyPinProvider>(
      builder: (context, provider, child) {
        return AuthFilledButton(
          onPressed: () async {
            //
          },
          state: provider.buttonState,
          title: 'Masuk',
        );
      },
    );
  }

  _buildButtonLupaPin() {
    return Consumer<VerifyPinProvider>(
      builder: (context, provider, child) {
        return TextButton(
          onPressed: () {
            provider.onPressedButtonLupaPin(
              phone: widget.phone,
            );
          },
          child: Text(
            'Lupa PIN',
            style: PasarAjaTypography.sfProDisplay.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        );
      },
    );
  }
}
