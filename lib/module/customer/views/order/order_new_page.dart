import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/config/themes/Typography.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/widgets/app_textfield.dart';
import 'package:pasaraja_mobile/config/widgets/image_network_error.dart';
import 'package:pasaraja_mobile/config/widgets/image_network_placeholder.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
import 'package:pasaraja_mobile/module/customer/models/cart_model.dart';
import 'package:pasaraja_mobile/module/customer/models/cart_product_model.dart';
import 'package:pasaraja_mobile/module/customer/provider/order/order_new_provider.dart';
import 'package:pasaraja_mobile/module/customer/widgets/customer_sub_appbar.dart';
import 'package:pasaraja_mobile/module/customer/widgets/item_rician_pembayaran.dart';
import 'package:provider/provider.dart';

class OrderNewPage extends StatefulWidget {
  const OrderNewPage({
    Key? key,
    required this.cart,
    required this.from,
  }) : super(key: key);

  final CartModel cart;
  final int from;

  static int fromCart = 1;
  static int fromNow = 2;

  @override
  State<OrderNewPage> createState() => _OrderNewPageState();
}

class _OrderNewPageState extends State<OrderNewPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<CustomerOrderNewProvider>().cartModel = widget.cart;
      context.read<CustomerOrderNewProvider>().from = widget.from;
      context.read<CustomerOrderNewProvider>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: customerSubAppbar('Buat Pesanan'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildShopData(),
              _buildProductData(),
              _buildTakenData(),
              _buildRicianPembayaran(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Consumer<CustomerOrderNewProvider>(
        builder: (context, provider, child) {
          return Visibility(
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 4,
                    blurRadius: 3,
                    offset: const Offset(0, -1),
                  ),
                ],
              ),
              child: Container(
                height: 60,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Total Harga : ',
                              style: PasarAjaTypography.sfpdSemibold),
                          Text(
                            'Rp. ${PasarAjaUtils.formatPrice(provider.totalPrice)}',
                            style: PasarAjaTypography.sfpdSemibold.copyWith(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        provider.onCreateOrderButtonPressed();
                      },
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 2.5,
                        height: 60,
                        child: Material(
                          color: PasarAjaColor.green1,
                          child: Center(
                            child: Text(
                              'Buat Pesanan',
                              style: PasarAjaTypography.sfpdSemibold.copyWith(
                                color: Colors.white,
                                fontSize: 15.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  _buildShopData() {
    return Consumer<CustomerOrderNewProvider>(
      builder: (context, provider, child) {
        var shopData = provider.cartModel.shopDataModel;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Informasi Toko',
              style: PasarAjaTypography.sfpdSemibold.copyWith(fontSize: 22),
            ),
            const Divider(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 70,
                  height: 70,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: shopData?.photo ?? '',
                      placeholder: (context, str) {
                        return const ImageNetworkPlaceholder();
                      },
                      errorWidget: (context, str, obj) {
                        return const ImageErrorNetwork();
                      },
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      shopData?.shopName ?? 'null',
                      style: PasarAjaTypography.sfpdSemibold
                          .copyWith(fontSize: 16),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      shopData?.benchmark ?? 'null',
                      maxLines: 2,
                      style: PasarAjaTypography.sfpdSemibold
                          .copyWith(fontSize: 15),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '+${shopData?.phoneNumber}',
                      style:
                          PasarAjaTypography.sfpdRegular.copyWith(fontSize: 15),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(),
          ],
        );
      },
    );
  }

  _buildProductData() {
    return Consumer<CustomerOrderNewProvider>(
      builder: (context, provider, child) {
        CartModel cart = provider.cartModel;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Rician Produk',
              style: PasarAjaTypography.sfpdSemibold.copyWith(fontSize: 22),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              itemCount: cart.products!.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                CartProductModel cartProd = cart.products![index];
                return Visibility(
                  visible: cartProd.checked,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 7),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 60,
                              height: 60,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl: cartProd.productData!.photo ?? '',
                                  placeholder: (context, str) {
                                    return const ImageNetworkPlaceholder();
                                  },
                                  errorWidget: (context, str, obj) {
                                    return const ImageErrorNetwork();
                                  },
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  cartProd.productData?.productName ?? 'null',
                                  style: PasarAjaTypography.sfpdSemibold
                                      .copyWith(fontSize: 15),
                                ),
                                PasarAjaUtils.isActivePromo(
                                        cartProd.productData!.promo)
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Rp. ${PasarAjaUtils.formatPrice(cartProd.productData?.price ?? 0)}",
                                            style: PasarAjaTypography
                                                .sfpdRegular
                                                .copyWith(
                                              fontSize: 15,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                            ),
                                          ),
                                          Text(
                                            "${cartProd.quantity} x Rp. ${PasarAjaUtils.formatPrice(cartProd.productData?.promo?.promoPrice ?? 0)} / ${cartProd.productData?.sellingUnit} ${cartProd.productData?.unit}",
                                            style: PasarAjaTypography
                                                .sfpdRegular
                                                .copyWith(fontSize: 15),
                                          ),
                                        ],
                                      )
                                    : Text(
                                        "${cartProd.quantity} x Rp. ${PasarAjaUtils.formatPrice(cartProd.productData?.price ?? 0)} / ${cartProd.productData?.sellingUnit} ${cartProd.productData?.unit}",
                                        style: PasarAjaTypography.sfpdRegular
                                            .copyWith(fontSize: 15),
                                      ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Visibility(
                          visible: (cartProd.notes != null &&
                              cartProd.notes!.isNotEmpty &&
                              cartProd.notes!.trim().isNotEmpty),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Catatan : ',
                                  style: PasarAjaTypography.sfpdSemibold
                                      .copyWith(fontSize: 15),
                                ),
                                TextSpan(
                                  text: cartProd.notes ?? '',
                                  style: PasarAjaTypography.sfpdRegular
                                      .copyWith(fontSize: 15),
                                ),
                              ],
                            ),
                            maxLines: 5,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Divider(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  _buildTakenData() {
    return Consumer<CustomerOrderNewProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Tanggal Pengambilan',
              style: PasarAjaTypography.sfpdSemibold.copyWith(fontSize: 22),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.only(right: Get.width / 6),
              child: InkWell(
                onTap: () async {
                  provider.selectTakenDate(context);
                },
                child: AbsorbPointer(
                  child: AppTextField(
                    hintText: 'Masukan Tanggal',
                    fontSize: 21,
                    controller: provider.takenDateCont,
                    // errorText: provider.vStartDate.message,
                    suffixIcon: const Icon(Icons.calendar_today),
                    readOnly: true,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Penting : ',
                    style:
                        PasarAjaTypography.sfpdSemibold.copyWith(fontSize: 15),
                  ),
                  TextSpan(
                    text:
                        "Harap datang dan ambil barang Anda di pasar sesuai dengan tanggal yang Anda masukkan",
                    style:
                        PasarAjaTypography.sfpdRegular.copyWith(fontSize: 15),
                  ),
                ],
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 10),
            const Divider(),
          ],
        );
      },
    );
  }

  _buildRicianPembayaran() {
    return Consumer<CustomerOrderNewProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Rician Pembayaran',
              style: PasarAjaTypography.sfpdSemibold.copyWith(fontSize: 22),
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ItemRicianPembayaran(
                  leftText: 'Total Produk',
                  rightText: '${provider.totalProduct} Produk',
                ),
                ItemRicianPembayaran(
                  leftText: 'Sub Total',
                  rightText: 'Rp. ${PasarAjaUtils.formatPrice(provider.subTotal)}',
                ),
                ItemRicianPembayaran(
                  leftText: 'Total Promo',
                  rightText: 'Rp. ${PasarAjaUtils.formatPrice(provider.totalPromo)}',
                ),
                ItemRicianPembayaran(
                  leftText: 'Total Harga',
                  rightText: 'Rp. ${PasarAjaUtils.formatPrice(provider.totalPrice)}',
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
