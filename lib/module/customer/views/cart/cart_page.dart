import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/Typography.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/widgets/loading_indicator.dart';
import 'package:pasaraja_mobile/config/widgets/page_error_message.dart';
import 'package:pasaraja_mobile/config/widgets/something_wrong.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
import 'package:pasaraja_mobile/module/customer/models/cart_model.dart';
import 'package:pasaraja_mobile/module/customer/provider/cart/cart_provider.dart';
import 'package:pasaraja_mobile/module/customer/widgets/cart_product_item.dart';
import 'package:pasaraja_mobile/module/customer/widgets/customer_sub_appbar.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<CartProvider>().fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customerSubAppbar('Keranjang'),
      body: Consumer<CartProvider>(
        builder: (context, provider, child) {
          if (provider.state is OnLoadingState) {
            return const LoadingIndicator();
          }

          if (provider.state is OnFailureState) {
            return PageErrorMessage(
                onFailureState: provider.state as OnFailureState);
          }

          if (provider.state is OnSuccessState) {
            var cartList = provider.carts;
            if (cartList.isEmpty) {
              return const Center(
                child: Text('durung ono keranjang'),
              );
            }
            return Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ListView.builder(
                itemCount: cartList.length,
                itemBuilder: (context, index) {
                  CartModel cart = cartList[index];
                  if (cart.products!.isEmpty) {
                    return const Material();
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Visibility(
                            visible: false,
                            child: Checkbox(
                              value: cart.checkedAll,
                              onChanged: (s) {
                                provider.checkedAll(index);
                              },
                            ),
                          ),
                          Text(
                            cart.shopDataModel?.shopName ?? 'null',
                            style: PasarAjaTypography.sfpdBold
                                .copyWith(fontSize: 25),
                          ),
                        ],
                      ),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: cart.products!
                              .map((e) => CartItem(
                                    product: e,
                                    onCheckboxChanged: (cek) {
                                      provider.checkboxChange(e);
                                    },
                                    onTapQty: () {
                                      provider.updateQuantity(context, e);
                                    },
                                    onPlusOneCart: () {
                                      provider.plusOneQuantity(e);
                                    },
                                    onMinusOneCart: () {
                                      provider.minusOneQuantity(e);
                                    },
                                    onSaveChanges: () {
                                      provider.saveChanges(e);
                                    },
                                    onAddNotes: () {
                                      provider.addNotes(context, e);
                                    },
                                    onDeleteProduct: () {
                                      provider.deleteProduct(e);
                                    },
                                  ))
                              .toList(),
                        ),
                      )
                    ],
                  );
                },
              ),
            );
          }

          return const SomethingWrong();
        },
      ),
      bottomNavigationBar: Consumer<CartProvider>(
        builder: (context, provider, child) {
          return Visibility(
            visible: provider.state is OnSuccessState,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 3,
                    blurRadius: 2,
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
                            'Rp. ${PasarAjaUtils.formatPrice(provider.totalPriceSelected)}',
                            style: PasarAjaTypography.sfpdSemibold.copyWith(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
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
}
