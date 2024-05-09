import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/images.dart';
import 'package:pasaraja_mobile/config/widgets/app_bar.dart';
import 'package:pasaraja_mobile/config/widgets/even_title_model.dart';
import 'package:pasaraja_mobile/core/constants/gojek_promo_data.dart';
import 'package:pasaraja_mobile/core/constants/gomart_data.dart';
import 'package:pasaraja_mobile/config/widgets/gomart_list.dart';
import 'package:pasaraja_mobile/config/widgets/gopay_list.dart';
import 'package:pasaraja_mobile/config/widgets/loading_indicator.dart';
import 'package:pasaraja_mobile/config/widgets/page_error_message.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
import 'package:pasaraja_mobile/config/widgets/gojek_promo.dart';
import 'package:pasaraja_mobile/config/widgets/gojek_second.dart';
import 'package:pasaraja_mobile/module/customer/provider/home/home_provider.dart';
import 'package:pasaraja_mobile/module/customer/views/home/profile_page.dart';
import 'package:pasaraja_mobile/module/customer/widgets/photo_profile.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // await context.read<HomeProvider>().fetchData();
      await fetchData();
    });
  }

  Future<void> fetchData() async{
    await context.read<HomeProvider>().fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async{
        await PasarAjaConstant.onRefreshDelay;
        await fetchData();
      },
      child: Scaffold(
        backgroundColor: PasarAjaColor.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
            97 - MediaQuery.of(context).padding.top,
          ),
          child: Consumer<HomeProvider>(
            builder: (context, provider, child) {
              return PasarAjaAppbar(
                title: 'Beranda',
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
        body: Consumer<HomeProvider>(
          builder: (context, provider, child) {
            if (provider.state is OnLoadingState) {
              return const LoadingIndicator();
            }

            if (provider.state is OnFailureState) {
              return PageErrorMessage(
                  onFailureState: provider.state as OnFailureState);
            }

            if (provider.state is OnSuccessState) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      PasarAjaImage.iklan,
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height / 4.165,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                    ),
                    const SizedBox(height: 20),
                    GoFoodSecond(
                      eventTitle: EventTitleModel(
                        title: 'Resto dengan rating jempolan',
                        deskripsi: 'Ad',
                        contentSpace: 19,
                      ),
                      models: PasarAjaUtils.shuffleList(provider.berandaModel.products!),
                    ),
                    const SizedBox(height: 20),
                    GoFoodSecond(
                      eventTitle: EventTitleModel(
                        icon: PasarAjaImage.gofood,
                        title: 'Pilihan Terlaris',
                        deskripsi: '',
                        haveButton: true,
                        btnTitle: 'Lihat semua',
                        contentSpace: 10,
                      ),
                      models: PasarAjaUtils.shuffleList(provider.berandaModel.products!),
                    ),
                    const SizedBox(height: 20),
                    GoFoodSecond(
                      eventTitle: EventTitleModel(
                        icon: PasarAjaImage.gofood,
                        title: 'Pilihan Terlaris',
                        deskripsi: '',
                        haveButton: true,
                        btnTitle: 'Lihat semua',
                        contentSpace: 10,
                      ),
                      models: PasarAjaUtils.shuffleList(provider.berandaModel.products!),
                    ),
                    const SizedBox(height: 20),
                    GojekPromo(gojekPromo: gojekPromo3),
                    const SizedBox(height: 20),
                    GomartList(
                      eventTitle: EventTitleModel(
                        icon: PasarAjaImage.gomart,
                        title: "Belanja di Pasar Wage, Pasti Ada!",
                        deskripsi: "Butuh apa? di Pasar Wage, belanja di PasarAja 🛒",
                        haveButton: true,
                        btnTitle: 'Lihat semua',
                      ),
                      list: gomartData,
                    ),
                    const SizedBox(height: 20),
                    GoPayList(
                      model: EventTitleModel(
                        icon: PasarAjaImage.gopay,
                        iconSize: 15,
                        title: 'Event Pasar Wage 🥀',
                        deskripsi: "Datang Ke Pasar Wage untuk kegiatan bersama",
                        contentSpace: 12,
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
