import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/images.dart';
import 'package:pasaraja_mobile/module/auth/models/user_model.dart';
import 'package:pasaraja_mobile/module/auth/providers/signup/signup_fourth_provider.dart';
import 'package:pasaraja_mobile/module/auth/widgets/widgets.dart';
import 'package:provider/provider.dart';

class SignUpFourthPage extends StatefulWidget {
  final UserModel user;
  final String createdPin;
  const SignUpFourthPage({
    super.key,
    required this.user,
    required this.createdPin,
  });

  @override
  State<SignUpFourthPage> createState() => _SignUpFourthPageState();
}

class _SignUpFourthPageState extends State<SignUpFourthPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<SignUpFourthProvider>(context, listen: false).resetData();
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
              top: 176 - MediaQuery.of(context).padding.top),
          child: Column(
            children: [
              const AuthInit(
                image: PasarAjaImage.ilConfirmPin,
                title: 'Konfirmasi PIN',
                description:
                    'Ketik ulang PIN Anda untuk memverifikasi pembuatan PIN.',
              ),
              const SizedBox(height: 19),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Column(
                  children: [_buildInputPin()],
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: _buildHelperText(),
              ),
              const SizedBox(height: 30),
              _buildButtonBuatAkun(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  _buildInputPin() {
    return Consumer<SignUpFourthProvider>(
      builder: (context, provider, child) {
        return AuthInputPin(
          title: 'Masukan PIN',
          authPin: AuthPin(
            length: 6,
            onChanged: (value) {
              provider.onValidatePin('', '23');
              provider.message = '';
            },
            onCompleted: (value) {
              provider.onValidatePin(widget.createdPin, value);
              DMethod.log('Password Page : ${widget.createdPin}');
              DMethod.log('Konfirmasi Page : $value');
            },
          ),
        );
      },
    );
  }

  _buildHelperText() {
    return Consumer<SignUpFourthProvider>(
      builder: (context, provider, child) {
        return AuthHelperText(
          title: provider.message.toString(),
        );
      },
    );
  }

  _buildButtonBuatAkun() {
    return Consumer<SignUpFourthProvider>(
      builder: (context, provider, child) {
        return AuthFilledButton(
          onPressed: () {
            provider.onPressedButtonBuatAkun(
              user: widget.user,
              createdPin: widget.createdPin,
            );
            DMethod.log('user : ${widget.user.fullName}');
            DMethod.log('phone : ${widget.user.phoneNumber}');
            DMethod.log('password : ${widget.user.password}');
            DMethod.log('pin : ${widget.createdPin}');
          },
          state: provider.buttonState,
          title: 'Buat Akun',
        );
      },
    );
  }
}
