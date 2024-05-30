import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/config/themes/Typography.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/icons.dart';
import 'package:pasaraja_mobile/config/themes/images.dart';
import 'package:pasaraja_mobile/config/widgets/app_bar.dart';
import 'package:pasaraja_mobile/config/widgets/image_network_error.dart';
import 'package:pasaraja_mobile/config/widgets/image_network_placeholder.dart';
import 'package:pasaraja_mobile/config/widgets/loading_indicator.dart';
import 'package:pasaraja_mobile/config/widgets/page_error_message.dart';
import 'package:pasaraja_mobile/config/widgets/something_wrong.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/module/auth/widgets/outlined_button.dart';
import 'package:pasaraja_mobile/module/merchant/providers/myshop/myshop_provider.dart';
import 'package:pasaraja_mobile/module/merchant/views/myshop/edit_operational_page.dart';
import 'package:pasaraja_mobile/module/merchant/views/myshop/edit_shop_page.dart';
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
      await fetchData();
    });
  }

  Future<void> fetchData() async {
    try {
      await context.read<MyShopProvider>().fetchData();
    } catch (ex) {
      Fluttertoast.showToast(msg: ex.toString());
    }
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
      body: RefreshIndicator(
        onRefresh: () async {
          await PasarAjaConstant.onRefreshDelay;
          await fetchData();
        },
        child: Consumer<MyShopProvider>(
          builder: (context, provider, child) {
            if (provider.state is OnLoadingState) {
              return const LoadingIndicator();
            }

            if (provider.state is OnFailureState) {
              return PageErrorMessage(
                onFailureState: provider.state as OnFailureState,
              );
            }

            if (provider.state is OnSuccessState) {
              var toko = provider.shopData;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 200,
                      width: Get.width,
                      color: Colors.grey[400],
                      child: CachedNetworkImage(
                        imageUrl: toko.photo! ?? '',
                        placeholder: (context, str) {
                          return const ImageNetworkPlaceholder();
                        },
                        errorWidget: (context, d, a) {
                          return const ImageErrorNetwork();
                        },
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: Text(
                        toko.shopName ?? '',
                        style: PasarAjaTypography.bold18,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        //rating toko
                        Container(
                            margin: const EdgeInsets.only(left: 60),
                            height: 40,
                            width: 100,
                            decoration: BoxDecoration(
                                boxShadow: const [
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
                                const SizedBox(width: 10),
                                Container(
                                  margin: const EdgeInsets.only(left: 7),
                                  child: SvgPicture.asset(
                                    PasarAjaIcon.rating,
                                    width: 20,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  "${toko.totalRating}",
                                  style: PasarAjaTypography.bold16,
                                )
                              ],
                            )),
                        const SizedBox(width: 40),
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
                              boxShadow: const [
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
                                const SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(right: 5),
                                  child: Image.asset(
                                    PasarAjaIcon.dani9,
                                    width: 23,
                                  ),
                                ),
                                Text(
                                  "Operasional",
                                  style: PasarAjaTypography.semibold12_5,
                                ),
                                const Icon(Icons.arrow_forward_ios_outlined)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      margin: const EdgeInsets.only(left: 25),
                      child: Text(
                        "Informasi Pasar",
                        style: PasarAjaTypography.bold18,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 35),
                          child: Text(
                            "Pemilik Pasar:",
                            style: PasarAjaTypography.sfpdAuthDescription,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 5),
                          child: Text(
                            toko.ownerName ?? '',
                            style: PasarAjaTypography.sfpdAuthDescription,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Container(
                            height: 35,
                            width: 35,
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: PasarAjaColor.white2,
                            ),
                            margin: const EdgeInsets.only(left: 25),
                            child: Image.asset(PasarAjaIcon.dani2),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 5),
                            child: Text(
                              toko.benchmark ?? '',
                              maxLines: 3,
                              style: PasarAjaTypography.sfpdAuthDescription
                                  .copyWith(
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Row(
                        children: [
                          Container(
                            height: 35,
                            width: 35,
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              // border:
                              //     Border.all(width: 2, color: PasarAjaColor.gray3),
                              borderRadius: BorderRadius.circular(8),
                              color: PasarAjaColor.white2,
                            ),
                            margin: const EdgeInsets.only(left: 25),
                            child: Image.asset(PasarAjaIcon.dani3),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 5),
                            child: Text(
                              toko.phoneNumber ?? '',
                              style: PasarAjaTypography.sfpdAuthDescription,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Row(
                        children: [
                          Container(
                            height: 35,
                            width: 35,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              // border:
                              //     Border.all(width: 1, color: PasarAjaColor.gray3),
                              borderRadius: BorderRadius.circular(8),
                              color: PasarAjaColor.white2,
                            ),
                            margin: const EdgeInsets.only(left: 25),
                            child: Image.asset(PasarAjaIcon.dani8),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 5),
                            child: Text(
                              "Deskripsi Pasar",
                              style: PasarAjaTypography.semibold14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: null,
                      //berfungsi untuk mengatur tinggi otomatis sesuai isi
                      margin: const EdgeInsets.only(left: 55, right: 20),
                      child: Text(
                        toko.description ?? '',
                        maxLines: 10,
                        textAlign: TextAlign.justify,
                        style: PasarAjaTypography.sfpdAuthDescription,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 40),
                          height: 100,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                width: 1, color: PasarAjaColor.gray3),
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 5),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Total Produk:",
                                  style: PasarAjaTypography.sfpdAuthDescription,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 17),
                                child: Text(
                                  "${toko.totalProduct}",
                                  style: PasarAjaTypography.sfpdBoldAuthInput,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 20),
                          height: 100,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                width: 1, color: PasarAjaColor.gray3),
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 5),
                              Align(
                                alignment: Alignment.center,
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Total Produk Terjual:",
                                        style: PasarAjaTypography
                                            .sfpdAuthDescription,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Text(
                                "${toko.totalSold}",
                                style: PasarAjaTypography.sfpdBoldAuthInput,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 40),
                          height: 100,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                width: 1, color: PasarAjaColor.gray3),
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 5),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Total Promo:",
                                  style: PasarAjaTypography.sfpdAuthDescription,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 17),
                                child: Text(
                                  "${toko.totalPromo}",
                                  style: PasarAjaTypography.sfpdBoldAuthInput,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 20),
                          height: 100,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                width: 1, color: PasarAjaColor.gray3),
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 5),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Total Transaksi :",
                                  style: PasarAjaTypography.sfpdAuthDescription,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 17),
                                child: Text(
                                  "${toko.totalTransaction}",
                                  style: PasarAjaTypography.sfpdBoldAuthInput,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 40),
                          height: 100,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                width: 1, color: PasarAjaColor.gray3),
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 5),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Total Review:",
                                  style: PasarAjaTypography.sfpdAuthDescription,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 17),
                                child: Text(
                                  "${toko.totalReview}",
                                  style: PasarAjaTypography.sfpdBoldAuthInput,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 20),
                          height: 100,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              width: 1,
                              color: PasarAjaColor.gray3,
                            ),
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 5),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Total Complain:",
                                  style: PasarAjaTypography.sfpdAuthDescription,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 17),
                                child: Text(
                                  "${toko.totalComplain}",
                                  style: PasarAjaTypography.sfpdBoldAuthInput,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    Center(
                      child: AuthOutlinedButton(
                        onPressed: () {
                          Get.to(
                            EditShopPage(shopData: toko,),
                            transition: Transition.downToUp,
                          );
                        },
                        title: 'Edit Toko',
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              );
            }

            return const SomethingWrong();
          },
        ),
      ),
    );
  }
}
