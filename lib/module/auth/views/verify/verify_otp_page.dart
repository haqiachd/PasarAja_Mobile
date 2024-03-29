import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/images.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/utils/messages.dart';
import 'package:pasaraja_mobile/module/auth/models/verification_model.dart';
import 'package:pasaraja_mobile/module/auth/providers/verify/verify_otp_provider.dart';
import 'package:pasaraja_mobile/module/auth/views/welcome_page.dart';
import 'package:pasaraja_mobile/module/auth/widgets/widgets.dart';
import 'package:provider/provider.dart';

class VerifyOtpPage extends StatefulWidget {
  static const int fromLoginGoogle = 1;
  static const int fromRegister = 2;
  static const int fromForgotPin = 3;
  //
  final VerificationModel verificationModel;
  final String? recipient;
  final int? from;
  final dynamic data;
  const VerifyOtpPage({
    super.key,
    required this.verificationModel,
    required this.from,
    required this.recipient,
    required this.data,
  });

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<VerifyOtpProvider>(context, listen: false).resetData();
      Provider.of<VerifyOtpProvider>(context, listen: false).playTimer();
      DMethod.log('TIMER STARTED');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          final metu = await PasarAjaMessage.showConfirmBack(
            "Apakah Anda yakin ingin keluar dari verifikasi OTP. \nKode OTP Anda akan hangus",
          );

          if (metu) {
            // ignore: use_build_context_synchronously
            Provider.of<VerifyOtpProvider>(context, listen: false).onDispose();
            Get.offAll(
              const WelcomePage(),
              transition: Transition.rightToLeft,
              duration: PasarAjaConstant.transitionDuration,
            );
          }
        }
      },
      child: Scaffold(
        backgroundColor: PasarAjaColor.white,
        appBar: authAppbar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: 19,
              right: 19,
              top: 176 - MediaQuery.of(context).padding.top,
            ),
            child: Column(
              children: [
                const AuthInit(
                  image: PasarAjaImage.ilVerifyOtp,
                  title: 'Verifikasi OTP',
                  description:
                      'Silakan masukkan kode OTP yang telah kami kirimkan ke nomor HP Anda.',
                ),
                const SizedBox(height: 19),
                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: _buildInputOtp(),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: _buildHelperMessage(),
                ),
                const SizedBox(height: 30),
                _buildButtonKirimUlang(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Input OTP
  _buildInputOtp() {
    return Consumer<VerifyOtpProvider>(builder: (context, provider, child) {
      return AuthInputPin(
        title: 'Masukan OTP',
        authPin: AuthPin(
          length: 4,
          onChanged: (value) {
            provider.message = '';
          },
          onCompleted: (value) async {
            provider.onCompletePin(
              from: widget.from!,
              verify: widget.verificationModel,
              otp: value,
              data: widget.data,
            );
          },
        ),
      );
    });
  }

  // Helper Message
  _buildHelperMessage() {
    return Consumer<VerifyOtpProvider>(
      builder: (context, provider, child) {
        return AuthHelperText(
          title: provider.message.toString(),
        );
      },
    );
  }

  /// Button Kirim Ulang
  _buildButtonKirimUlang() {
    return Consumer<VerifyOtpProvider>(
      builder: (context, provider, child) {
        DMethod.log('rebuild button filled');
        return AuthFilledButton(
          onPressed: () async {
            provider.onPressedButtonKirimUlang(
              email: widget.recipient!,
              from: widget.from!,
              data: widget.data,
            );
          },
          state: provider.buttonState,
          title: provider.timeStatus.toString(),
        );
      },
    );
  }
}
