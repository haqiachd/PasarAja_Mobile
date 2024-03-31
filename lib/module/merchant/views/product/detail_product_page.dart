import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';
import 'package:pasaraja_mobile/config/widgets/loading_indicator.dart';
import 'package:pasaraja_mobile/config/widgets/page_error_message.dart';
import 'package:pasaraja_mobile/config/widgets/something_wrong.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
import 'package:pasaraja_mobile/module/merchant/models/complain_model.dart';
import 'package:pasaraja_mobile/module/merchant/models/product/product_detail_page_model.dart';
import 'package:pasaraja_mobile/module/merchant/models/product_histories_model.dart';
import 'package:pasaraja_mobile/module/merchant/models/review_model.dart';
import 'package:pasaraja_mobile/module/merchant/providers/product/detail_product_provider.dart';
import 'package:pasaraja_mobile/module/merchant/views/product/detail_list_page.dart';
import 'package:pasaraja_mobile/module/merchant/views/product/edit_product_page.dart';
import 'package:pasaraja_mobile/module/merchant/widgets/action_button.dart';
import 'package:pasaraja_mobile/module/merchant/widgets/item_complain.dart';
import 'package:pasaraja_mobile/module/merchant/widgets/item_history.dart';
import 'package:pasaraja_mobile/module/merchant/widgets/item_ulasan.dart';
import 'package:pasaraja_mobile/module/merchant/widgets/switcher_setting.dart';
import 'package:provider/provider.dart';

class DetailProductPage extends StatefulWidget {
  final int idProduct;
  const DetailProductPage({
    super.key,
    required this.idProduct,
  });

  @override
  State<DetailProductPage> createState() => _DetailProductPageState();
}

class _DetailProductPageState extends State<DetailProductPage> {
  // limit list and transiton list
  final int _limit = 1;
  final _transition = Transition.cupertino;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      try {
        await Provider.of<DetailProductProvider>(context, listen: false)
            .fetchData(
          idProduct: widget.idProduct,
        );
      } catch (ex) {
        Fluttertoast.showToast(msg: PasarAjaConstant.unknownError);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(0, -MediaQuery.of(context).padding.top),
        child: AppBar(
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.keyboard_return,
              color: Colors.white,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Consumer<DetailProductProvider>(
        builder: (context, value, child) {
          if (value.state is OnLoadingState) {
            return const LoadingIndicator();
          }

          if (value.state is OnFailureState) {
            return PageErrorMessage(
              onFailureState: value.state as OnFailureState,
            );
          }

          if (value.state is OnSuccessState) {
            final product = value.detailProd;
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  floating: true,
                  expandedHeight: 240,
                  leading: Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.back_hand),
                      color: Colors.white,
                    ),
                  ),
                  systemOverlayStyle: const SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent,
                    statusBarIconBrightness: Brightness.light,
                  ),
                  flexibleSpace: LayoutBuilder(
                    builder: (context, constraints) {
                      // Check if the app bar is expanded (scrolled)
                      bool isExpanded = constraints.maxHeight > kToolbarHeight;
                      return FlexibleSpaceBar(
                        title: !isExpanded
                            ? Text(
                                'Detail',
                                style: PasarAjaTypography.sfpdBold.copyWith(
                                  color: Colors.black,
                                ),
                              )
                            : null,
                        background: CachedNetworkImage(
                          imageUrl: product.photo ?? '',
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        _productInfo(product),
                        const SizedBox(height: 10),
                        _keteranganProduct(),
                        const SizedBox(height: 10),
                        _ulasanPengguna(product.reviews),
                        const SizedBox(height: 10),
                        _complainPengguna(product.complains),
                        const SizedBox(height: 10),
                        _historyTrx(product.histories),
                        const SizedBox(height: 60),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return const SomethingWrong();
        },
        child: Center(
          child: Text("Detail Product", style: PasarAjaTypography.sfpdBold),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buttonSetting(context),
          const SizedBox(width: 10),
          _buttonEdit(),
          const SizedBox(width: 10),
          _buttonDelete(context),
        ],
      ),
    );
  }

  _buttonSetting(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Keterangan Produk',
                    style: PasarAjaTypography.sfpdBold.copyWith(
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Consumer<DetailProductProvider>(
                    builder: (context, value, child) {
                      return SwitcherSetting(
                        title: 'Stok Tersedia',
                        value: value.isAvailableTemp,
                        onChanged: (value) {
                          context
                              .read<DetailProductProvider>()
                              .isAvailableTemp = value;
                        },
                      );
                    },
                  ),
                  Consumer<DetailProductProvider>(
                    builder: (context, value, child) {
                      return SwitcherSetting(
                        title: 'Rekomendasikan Produk',
                        value: value.isRecommendedTemp,
                        onChanged: (value) {
                          context
                              .read<DetailProductProvider>()
                              .isRecommendedTemp = value;
                        },
                      );
                    },
                  ),
                  Consumer<DetailProductProvider>(
                    builder: (context, value, child) {
                      return SwitcherSetting(
                        title: 'Tampilkan Produk',
                        value: value.isShownTemp,
                        onChanged: (value) {
                          context.read<DetailProductProvider>().isShownTemp =
                              value;
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 20.0),
                  ActionButton(
                    title: 'Simpan',
                    state: ActionButton.stateEnabledButton,
                    onPressed: () {
                      context.read<DetailProductProvider>().updateSettings(
                            idProduct: widget.idProduct,
                          );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
      heroTag: 'settingsprod',
      backgroundColor: Colors.blueGrey[300],
      child: const Icon(
        Icons.settings,
        color: Colors.white,
      ),
    );
  }

  _buttonDelete(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        // delete provider
        context.read<DetailProductProvider>().onPressedDelete(
              idProduct: widget.idProduct,
            );
      },
      heroTag: 'deleteprod',
      backgroundColor: Colors.redAccent[100],
      child: const Icon(
        Icons.delete,
        color: Colors.white,
      ),
    );
  }

  _buttonEdit() {
    return FloatingActionButton(
      onPressed: () {
        Get.to(const EditProductPage());
      },
      heroTag: 'editprod',
      backgroundColor: Colors.blueAccent[100],
      child: const Icon(
        Icons.edit,
        color: Colors.white,
      ),
    );
  }

  _productInfo(ProductDetailModel product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.productName ?? 'Null',
          style: PasarAjaTypography.sfpdBold.copyWith(
            fontSize: 30,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          "${product.categoryName}",
          style: PasarAjaTypography.sfpdSemibold.copyWith(
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            const Icon(
              Icons.star,
              color: Colors.orange,
            ),
            const SizedBox(width: 5),
            if (product.totalReview! > 0)
              Row(
                children: [
                  Text(
                    product.rating.toString(),
                    style: PasarAjaTypography.sfpdSemibold,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    "(${product.totalReview})",
                    style: PasarAjaTypography.sfpdSemibold,
                  ),
                ],
              )
            else
              Text(
                'belum ada ulasan',
                style: PasarAjaTypography.sfpdSemibold,
              ),
            const SizedBox(width: 5),
            Text(
              '*',
              style: PasarAjaTypography.sfpdBold,
            ),
            const SizedBox(width: 5),
            Text(
              '${product.totalSold} terjual',
              style: PasarAjaTypography.sfpdSemibold,
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          "${PasarAjaUtils.formatPrice(product.price ?? 0)} / ${product.sellingUnit} ${product.unit}",
          style: PasarAjaTypography.sfpdRegular.copyWith(fontSize: 25),
        ),
        const SizedBox(height: 10),
        Text(
          product.description ?? '',
          style: PasarAjaTypography.sfpdRegular,
        ),
      ],
    );
  }

  _keteranganProduct() {
    return Consumer<DetailProductProvider>(
      builder: (context, value, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Keterangan Produk",
              style: PasarAjaTypography.sfpdBold.copyWith(
                fontSize: 20,
              ),
            ),
            Text(
              "Ketersediaan Stok : ${value.isAvailable}",
              style: PasarAjaTypography.sfpdMedium,
            ),
            const SizedBox(height: 3),
            Text(
              "Direkomendasikan : ${value.isRecommended}",
              style: PasarAjaTypography.sfpdMedium,
            ),
            const SizedBox(height: 3),
            Text(
              "Ditampilkan : ${value.isShown}",
              textAlign: TextAlign.justify,
              style: PasarAjaTypography.sfpdMedium,
            ),
          ],
        );
      },
    );
  }

  Center _nothingList(String msg) {
    return Center(
      child: Text(
        msg,
        style: PasarAjaTypography.sfpdSemibold,
      ),
    );
  }

  Text _listTitle(String title) {
    return Text(
      title,
      style: PasarAjaTypography.sfpdBold.copyWith(
        fontSize: 20,
      ),
    );
  }

  TextButton _seeAll(VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: const Text(
        'See All',
        style: TextStyle(color: Colors.blue),
      ),
    );
  }

  Widget _ulasanPengguna(List<ReviewModel>? reviews) {
    // limit list review
    List<ReviewModel>? limitedReviews = reviews?.take(_limit).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // menampilkan list
        _listTitle("Ulasan Pengguna"),
        if (limitedReviews != null && limitedReviews.isNotEmpty)
          ...limitedReviews.map(
            (e) => ItemUlasan(
              review: e,
              showProduct: false,
            ),
          ),
        // menampilkan button lihat semua
        if (reviews != null && reviews.length > _limit)
          _seeAll(
            () {
              Get.to(
                DetailListPage(
                  title: "Ulasan Pembeli",
                  type: DetailListPage.listReview,
                  idProduct: widget.idProduct,
                ),
                transition: _transition,
              );
            },
          ),
        if (reviews == null || reviews.isEmpty)
          _nothingList("Belum ada ulasan"),
      ],
    );
  }

  Widget _complainPengguna(List<ComplainModel>? complains) {
    // limit list complain
    List<ComplainModel>? limitedComplains = complains?.take(_limit).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // show list
        _listTitle("Komplain Pengguna"),
        if (limitedComplains != null && limitedComplains.isNotEmpty)
          ...limitedComplains.map(
            (e) => ItemComplain(complain: e),
          ),
        if (complains != null && complains.length > _limit)
          _seeAll(
            () {
              Get.to(
                DetailListPage(
                  title: "Komplain Pembeli",
                  type: DetailListPage.listComplain,
                  idProduct: widget.idProduct,
                ),
                transition: _transition,
              );
            },
          ),
        if (complains == null || complains.isEmpty)
          _nothingList("Belum ada komplain"),
      ],
    );
  }

  Widget _historyTrx(List<ProductHistoriesModel>? histories) {
    // limit list history
    List<ProductHistoriesModel>? limitedHistories =
        histories?.take(_limit).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // menampilkan list
        _listTitle("Riwayat Transaksi"),
        if (limitedHistories != null && limitedHistories.isNotEmpty)
          ...limitedHistories.map(
            (e) => Align(
              alignment: Alignment.centerLeft,
              child: ItemHistory(history: e),
            ),
          ),
        if (histories != null && histories.length > _limit)
          _seeAll(
            () {
              Get.to(
                DetailListPage(
                  title: "Riwayat Transaksi",
                  type: DetailListPage.listHistory,
                  idProduct: widget.idProduct,
                ),
                transition: _transition,
              );
            },
          ),
        if (histories == null || histories.isEmpty)
          _nothingList("Belum ada riwayat transaksi"),
      ],
    );
  }
}
