import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/images.dart';
import 'package:pasaraja_mobile/module/auth/providers/change/change_pin_provider.dart';
import 'package:pasaraja_mobile/module/auth/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ChangePinPage extends StatefulWidget {
  final String phone;
  const ChangePinPage({
    super.key,
    required this.phone,
  });

  @override
  State<ChangePinPage> createState() => _ChangePinPageState();
}

class _ChangePinPageState extends State<ChangePinPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ChangePinProvider>(
        context,
        listen: false,
      ).resetData();
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
            top: 94 - MediaQuery.of(context).padding.top,
          ),
          child: Column(
            children: [
              const AuthInit(
                image: PasarAjaImage.ilCreate,
                title: 'Ganti PIN',
                description:
                    'Buatlah PIN yang kuat dan jangan bagikan PIN Anda kepada orang lain.',
              ),
              const SizedBox(height: 19),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 140),
                child: Column(
                  children: [
                    _buildInputPin(),
                    const SizedBox(height: 12),
                    _buildInputKonfirmasi()
                  ],
                ),
              ),
              const SizedBox(height: 40),
              _buildButtonGantiPin(context),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  _buildInputPin() {
    return Consumer<ChangePinProvider>(
      builder: (context, provider, child) {
        //
        final pinCont = provider.pinCont;

        return AuthInputText(
          title: 'Masukan PIN',
          textField: AuthTextField(
            controller: pinCont,
            maxLength: 6,
            keyboardType: TextInputType.number,
            formatters: AuthTextField.numberFormatter(),
            obscureText: provider.obscurePass,
            suffixIcon: AuthTextField.hiddenPassword(provider.obscurePass),
            hintText: 'xxxxxxx',
            errorText: provider.vPin.message,
            onChanged: (value) {
              provider.onValidatePin(
                value,
                provider.konfCont.text,
              );
            },
            suffixAction: () {
              provider.obscurePass = !provider.obscurePass;
            },
          ),
        );
      },
    );
  }

  _buildInputKonfirmasi() {
    return Consumer<ChangePinProvider>(
      builder: (context, provider, child) {
        //
        final konfCont = provider.konfCont;

        return AuthInputText(
          title: 'Konfirmasi PIN',
          textField: AuthTextField(
            controller: konfCont,
            maxLength: 6,
            keyboardType: TextInputType.number,
            formatters: AuthTextField.numberFormatter(),
            hintText: 'xxxxxxx',
            errorText: provider.vKonf.message,
            obscureText: provider.obscureKonf,
            suffixIcon: AuthTextField.hiddenPassword(provider.obscureKonf),
            onChanged: (value) {
              provider.onValidateKonf(
                provider.pinCont.text,
                value,
              );
            },
            suffixAction: () {
              provider.obscureKonf = !provider.obscureKonf;
            },
          ),
        );
      },
    );
  }

  _buildButtonGantiPin(BuildContext context) {
    return Consumer<ChangePinProvider>(
      builder: (context, provider, child) {
        return AuthFilledButton(
          onPressed: () {
            provider.onPressedButtonGantiPin(
              phone: widget.phone,
              pin: provider.pinCont.text,
            );
          },
          state: provider.buttonState,
          title: 'Ganti PIN',
        );
      },
    );
  }
}
