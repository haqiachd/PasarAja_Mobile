import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pasaraja_mobile/config/themes/lotties.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';

class PageErrorMessage extends StatelessWidget {
  final OnFailureState onFailureState;

  const PageErrorMessage({
    super.key,
    required this.onFailureState,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 3,
          child: LottieBuilder.asset(
            PasarAjaLottie.error,
          ),
        ),
        _buildError(),
      ],
    );
  }

  _buildError() {
    // tampilkan error dari dio
    if (onFailureState.dioException != null) {
      if (onFailureState.dioException!.error != null) {
        String mesagge = onFailureState.dioException!.error.toString();
        if (mesagge.isNotEmpty && mesagge.trim().isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                mesagge,
                textAlign: TextAlign.center,
                style: PasarAjaTypography.sfpdBold.copyWith(
                  fontSize: 18,
                ),
              ),
            ),
          );
        }
      }
    }

    // tampilkan error dari pesan
    if (onFailureState.message != null) {
      String message = onFailureState.message!;
      if (message.isNotEmpty && message.trim().isNotEmpty) {
        return Align(
          alignment: Alignment.center,
          child: Text(
            message,
            style: PasarAjaTypography.sfpdBold.copyWith(
              fontSize: 25,
            ),
          ),
        );
      }
    }

    // jika tidak terdapat dio dan pesan error
    return Align(
      alignment: Alignment.center,
      child: Text(
        PasarAjaConstant.unknownError,
        style: PasarAjaTypography.sfpdBold.copyWith(
          fontSize: 25,
          color: Colors.red,
        ),
      ),
    );
  }
}
