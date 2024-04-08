import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/icons.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';
import 'package:pasaraja_mobile/core/constants/local_data.dart';
import 'package:pasaraja_mobile/core/utils/messages.dart';
import 'package:pasaraja_mobile/module/auth/providers/providers.dart';
import 'package:pasaraja_mobile/module/auth/views/signin/signin_google_page.dart';
import 'package:pasaraja_mobile/module/auth/views/signup/signup_first_page.dart';
import 'package:pasaraja_mobile/module/auth/widgets/widgets.dart';
import 'package:pasaraja_mobile/module/auth/views/signin/signin_phone_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  int state = AuthFilledButton.stateEnabledButton;
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          final metu = await PasarAjaMessage.showConfirmBack(
            "Apakah Anda yakin ingin keluar dari Aplikasi",
          );

          if (metu) {
            exit(0);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark,
          ),
          toolbarHeight: -MediaQuery.of(context).padding.top,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 223 -
                      MediaQuery.of(context).padding.top +
                      MediaQuery.of(context).padding.bottom,
                ),
                _slider(context),
                const SizedBox(height: 43),
                _buildIndicator(),
                const SizedBox(height: 20),
                AuthFilledButton(
                  onPressed: _masukOnPressed(context),
                  state: state,
                  title: 'Ayo Masuk',
                ),
                const SizedBox(height: 16),
                AuthOutlinedButton(
                  onPressed: _registerOnPressed(context),
                  title: 'Daftarkan Diri Anda',
                ),
                const SizedBox(height: 40),
                const CopyrightText()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

_slider(BuildContext context) {
  return CarouselSlider(
    options: CarouselOptions(
      height: 340,
      initialPage: 0,
      viewportFraction: 1,
      reverse: false,
      enableInfiniteScroll: true,
      scrollDirection: Axis.horizontal,
      enlargeCenterPage: true,
      scrollPhysics: const BouncingScrollPhysics(),
      autoPlayCurve: Curves.ease,
      autoPlay: true,
      autoPlayInterval: const Duration(seconds: 5),
      animateToClosest: false,
      pageSnapping: false,
      enlargeStrategy: CenterPageEnlargeStrategy.zoom,
      onPageChanged: (index, reason) {
        context.read<WelcomeProvider>().currentIndex = index;
      },
    ),
    items: PasarAjaLocalData.wecomeList.map(
      (data) {
        return ItemWelcome(
          image: data.image,
          title: data.title,
          description: data.description,
        );
      },
    ).toList(),
  );
}

_buildIndicator() {
  return Consumer<WelcomeProvider>(
    builder: (context, prov, child) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: PasarAjaLocalData.wecomeList.asMap().entries.map(
          (entry) {
            int index = entry.key;
            return Padding(
              padding: const EdgeInsets.only(left: 3, right: 3),
              child: SizedBox(
                width: 7,
                height: 7,
                child: Material(
                  color: prov.currentIndex == index
                      ? PasarAjaColor.green1
                      : PasarAjaColor.gray2,
                  shape: const CircleBorder(),
                ),
              ),
            );
          },
        ).toList(),
      );
    },
  );
}

_masukOnPressed(BuildContext context) {
  return () {
    // Navigator.pushNamed(context, RouteName.loginPhone);
    showModalBottomSheet(
      context: context,
      builder: ((context) {
        return Container(
          width: double.infinity,
          height: 240,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 20),
              SvgPicture.asset(PasarAjaIcon.icLineIndicator),
              const SizedBox(height: 17),
              Padding(
                padding: const EdgeInsets.only(left: 18, right: 18),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Pilih Tipe Masuk',
                        textAlign: TextAlign.left,
                        style: PasarAjaTypography.sfpdBold.copyWith(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Anda ingin masuk lewat apa?',
                        textAlign: TextAlign.left,
                        style: PasarAjaTypography.sfpdRegular.copyWith(
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ChooseButton(
                      image: PasarAjaIcon.icGoogle,
                      title: 'Masuk Dengan Google',
                      onTap: () {
                        Navigator.of(context).pop();
                        // Navigator.pushNamed(context, RouteName.loginGoogle);
                        Get.to(
                          const SignInGooglePage(),
                          transition: Transition.downToUp,
                          duration: const Duration(milliseconds: 500),
                        );
                      },
                    ),
                    const SizedBox(height: 11),
                    ChooseButton(
                      image: PasarAjaIcon.icNumber,
                      title: 'Masuk Dengan Nomor HP',
                      onTap: () {
                        Navigator.of(context).pop();
                        Get.to(
                          const SignInPhonePage(),
                          transition: Transition.downToUp,
                          duration: const Duration(milliseconds: 500),
                        );
                      },
                    ),
                    const SizedBox(height: 27),
                  ],
                ),
              )
            ],
          ),
        );
      }),
    );
  };
}

_registerOnPressed(BuildContext context) {
  return () {
    Get.to(
      const SignUpFirstPage(),
      transition: Transition.downToUp,
      duration: const Duration(milliseconds: 500),
    );
  };
}
