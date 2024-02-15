import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/routes/route_names.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';
import 'package:pasaraja_mobile/core/constant/constants.dart';
import 'package:pasaraja_mobile/core/utils/local_data.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/item_welcome.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ...PasarAjaLocalData.wecomeList.map(
                      (data) => ItemWelcome(
                        image: data.image,
                        title: data.title,
                        description: data.description,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 43),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 3, right: 3),
                    child: SizedBox(
                      width: 5,
                      height: 5,
                      child: Material(
                        color: PasarAjaColor.green1,
                        shape: CircleBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 3, right: 3),
                    child: SizedBox(
                      width: 5,
                      height: 5,
                      child: Material(
                        color: PasarAjaColor.gray2,
                        shape: CircleBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 3, right: 3),
                    child: SizedBox(
                      width: 5,
                      height: 5,
                      child: Material(
                        color: PasarAjaColor.gray2,
                        shape: CircleBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 329,
                height: 43,
                child: ElevatedButton(
                  onPressed: () {
                    print('button pressed');
                    Navigator.pushNamed(context, RouteName.loginGoogle);
                  },
                  style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(PasarAjaColor.green2),
                    foregroundColor: MaterialStatePropertyAll(Colors.white),
                  ),
                  child: Text(
                    'Ayo Masuk',
                    style: PasarAjaTypography.sfpdAuthFilledButton,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 329,
                height: 43,
                child: OutlinedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                      side: const MaterialStatePropertyAll(
                        BorderSide(
                          width: 1.8,
                        ),
                      ),
                      foregroundColor: MaterialStateProperty.all(
                        PasarAjaColor.green2,
                      ),
                      overlayColor: MaterialStateProperty.all(
                        PasarAjaColor.green2.withOpacity(0.1),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      )),
                  child: const Text(
                    'Daftarkan Diri Anda',
                    style: TextStyle(
                      // Sesuaikan dengan gaya teks yang diinginkan
                      color: PasarAjaColor.green2, // Ubah ke warna yang sesuai
                      fontSize: 16, // Ubah ke ukuran font yang diinginkan
                      fontWeight: FontWeight
                          .bold, // Sesuaikan dengan ketebalan font yang diinginkan
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Text(
                PasarAjaConstant.rights,
                textAlign: TextAlign.center,
                style: PasarAjaTypography.sfpdRightText,
              )
            ],
          ),
        ),
      ),
    );
  }
}
