import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/config/themes/Typography.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/icons.dart';
import 'package:pasaraja_mobile/config/themes/images.dart';
import 'package:pasaraja_mobile/config/widgets/app_bar.dart';
import 'package:pasaraja_mobile/config/widgets/coming_soon.dart';
import 'package:pasaraja_mobile/module/merchant/providers/myshop/myshop_provider.dart';
import 'package:pasaraja_mobile/module/merchant/views/myshop/edit_operational_page.dart';
import 'package:pasaraja_mobile/module/merchant/views/myshop/profile_page.dart';
import 'package:pasaraja_mobile/module/merchant/widgets/photo_profile.dart';
import 'package:provider/provider.dart';

class MyShopPage extends StatefulWidget {
  const MyShopPage({super.key});

  @override
  State<MyShopPage> createState() => _MyShopPageState();
}

class _MyShopPageState extends State<MyShopPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<MyShopProvider>().fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PasarAjaColor.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          97 - MediaQuery.of(context).padding.top,
        ),
        child: Consumer<MyShopProvider>(
          builder: (context, provider, child) {
            return PasarAjaAppbar(
              title: 'Toko Saya',
              action: PhotoProfile(
                photoPath: provider.photoProfile,
                onTap: () {
                  Get.to(const ProfilePage());
                },
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 170,
              width: 450,
              color: Colors.grey[400],
              child: Image.asset(
                PasarAjaImage.hitler,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Text(
                "Nama Kios Mitra",
                style: PasarAjaTypography.bold18,
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                //rating toko
                Container(
                    margin: EdgeInsets.only(left: 60),
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: PasarAjaColor.gray3,
                            blurRadius: 9,
                            spreadRadius: 1,
                            offset: Offset(0, 7),
                          )
                        ],
                        color: PasarAjaColor.gray6,
                        borderRadius: BorderRadius.circular(7)),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 7),
                          child: SvgPicture.asset(
                            PasarAjaIcon.rating,
                            width: 20,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          child: Text(
                            "5.0",
                            style: PasarAjaTypography.bold16,
                          ),
                        )
                      ],
                    )),
                SizedBox(
                  width: 40,
                ),

                //waktu buka
                InkWell(
                  onTap: () {
                    Get.to(
                      const EditOperationalPage(),
                      transition: Transition.downToUp,
                    );
                  },
                  child: Container(
                    height: 40,
                    width: 140,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: PasarAjaColor.gray3,
                          blurRadius: 9,
                          spreadRadius: 1,
                          offset: Offset(0, 7),
                        )
                      ],
                      color: PasarAjaColor.gray6,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                            margin: EdgeInsets.only(right: 5),
                            child: Image.asset(
                              PasarAjaIcon.dani4,
                              width: 23,
                            )),
                        Container(
                          child: Text(
                            "Jam Buka",
                            style: PasarAjaTypography.semibold12_5,
                          ),
                        ),
                        Container(
                          child: Icon(Icons.arrow_forward_ios_outlined),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.only(left: 25),
              child: Text(
                "Informasi Pasar",
                style: PasarAjaTypography.bold18,
              ),
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 35),
                  child: Text(
                    "Kepala Pasar:",
                    style: PasarAjaTypography.sfpdAuthDescription,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 5),
                  child: Text(
                    "Nama Kepala pasar",
                    style: PasarAjaTypography.sfpdAuthDescription,
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  Container(
                    height: 35,
                    width: 35,
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(

                        // border:
                        //     Border.all(width: 2, color: PasarAjaColor.gray3),
                        borderRadius: BorderRadius.circular(8),
                        color: PasarAjaColor.white2,
                        boxShadow: [
                          // BoxShadow(
                          //     color: PasarAjaColor.gray3,
                          //     spreadRadius: 1,
                          //     blurRadius: 9,
                          //     offset: Offset(0, 9)
                          //     ),
                        ]),
                    margin: EdgeInsets.only(left: 25),
                    child: Image.asset(PasarAjaIcon.dani2),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 5),
                    child: Text(
                      "KERTOSONO - Nganjuk,Jawa Timur",
                      style: PasarAjaTypography.sfpdAuthDescription,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  Container(
                    height: 35,
                    width: 35,
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        // border:
                        //     Border.all(width: 2, color: PasarAjaColor.gray3),
                        borderRadius: BorderRadius.circular(8),
                        color: PasarAjaColor.white2,
                        boxShadow: [
                          // BoxShadow(
                          //     color: PasarAjaColor.gray3,
                          //     spreadRadius: 1,
                          //     blurRadius: 9,
                          //     offset: Offset(0, 9))
                        ]),
                    margin: EdgeInsets.only(left: 25),
                    child: Image.asset(PasarAjaIcon.dani3),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 5),
                    child: Text(
                      "+6282299518956",
                      style: PasarAjaTypography.sfpdAuthDescription,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  Container(
                    height: 35,
                    width: 35,
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        // border:
                        //     Border.all(width: 1, color: PasarAjaColor.gray3),
                        borderRadius: BorderRadius.circular(8),
                        color: PasarAjaColor.white2,
                        boxShadow: [
                          // BoxShadow(
                          //     color: PasarAjaColor.gray3,
                          //     spreadRadius: 1,
                          //     blurRadius: 9,
                          //     offset: Offset(0, 9)
                          //     )
                        ]),
                    margin: EdgeInsets.only(left: 25),
                    child: Image.asset(PasarAjaIcon.dani4),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 5),
                    child: Text(
                      "Deskripsi Pasar",
                      style: PasarAjaTypography.semibold14,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height:
                  null, //berfungsi untuk mengatur tinggi otomatis sesuai isi
              margin: EdgeInsets.only(left: 55),
              child: Text(
                "Lorem ipsum paramesidium jsnfjinfjifjibfjibdjis",
                style: PasarAjaTypography.sfpdAuthDescription,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 40),
                  height: 100,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(width: 1, color: PasarAjaColor.gray3),
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          child: Text(
                            "Total Produk:",
                            style: PasarAjaTypography.sfpdAuthDescription,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 17),
                        child: Text(
                          "10",
                          style: PasarAjaTypography.sfpdBoldAuthInput,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20),
                  height: 100,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(width: 1, color: PasarAjaColor.gray3),
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          child: RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                text: "Total Produk\nTerjual:",
                                style: PasarAjaTypography.sfpdAuthDescription,
                              )
                            ]),
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          "60",
                          style: PasarAjaTypography.sfpdBoldAuthInput,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 40),
                  height: 100,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(width: 1, color: PasarAjaColor.gray3),
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          child: Text(
                            "Total Transaksi:",
                            style: PasarAjaTypography.sfpdAuthDescription,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 17),
                        child: Text(
                          "59",
                          style: PasarAjaTypography.sfpdBoldAuthInput,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20),
                  height: 100,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(width: 1, color: PasarAjaColor.gray3),
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          child: Text(
                            "Total Pembeli:",
                            style: PasarAjaTypography.sfpdAuthDescription,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 17),
                        child: Text(
                          "20",
                          style: PasarAjaTypography.sfpdBoldAuthInput,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 40),
                  height: 100,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(width: 1, color: PasarAjaColor.gray3),
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          child: Text(
                            "Total Review:",
                            style: PasarAjaTypography.sfpdAuthDescription,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 17),
                        child: Text(
                          "20",
                          style: PasarAjaTypography.sfpdBoldAuthInput,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20),
                  height: 100,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(width: 1, color: PasarAjaColor.gray3),
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          child: Text(
                            "Total Complain:",
                            style: PasarAjaTypography.sfpdAuthDescription,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 17),
                        child: Text(
                          "0",
                          style: PasarAjaTypography.sfpdBoldAuthInput,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "data",
              style: PasarAjaTypography.sfpdBoldAuthInput,
            )
          ],
        ),
      ),
    );
  }
}

@override
void _showOpenHoursDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Detail Jam Buka"),
        content: Container(
          height: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Senin: 08:00 - 16:00"),
              Text("Selasa: 08:00 - 16:00"),
              Text("Rabu: 08:00 - 16:00"),
              Text("Kamis: 08:00 - 16:00"),
              Text("Jumat: 08:00 - 16:00"),
              Text("Sabtu: 08:00 - 16:00"),
              Text("Minggu: 08:00 - 16:00"),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text("Tutup"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
