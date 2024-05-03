import 'package:cached_network_image/cached_network_image.dart';
import 'package:d_method/d_method.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/config/themes/Typography.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/widgets/action_button.dart';
import 'package:pasaraja_mobile/config/widgets/image_network_error.dart';
import 'package:pasaraja_mobile/config/widgets/image_network_placeholder.dart';
import 'package:pasaraja_mobile/config/widgets/loading_indicator.dart';
import 'package:pasaraja_mobile/config/widgets/page_error_message.dart';
import 'package:pasaraja_mobile/config/widgets/something_wrong.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
import 'package:pasaraja_mobile/module/customer/models/product_detail_model.dart';
import 'package:pasaraja_mobile/module/customer/models/product_model.dart';
import 'package:pasaraja_mobile/module/customer/models/rating_model.dart';
import 'package:pasaraja_mobile/module/customer/models/review_model.dart';
import 'package:pasaraja_mobile/module/customer/models/shop_data_model.dart';
import 'package:pasaraja_mobile/module/customer/provider/providers.dart';
import 'package:pasaraja_mobile/module/customer/widgets/item_ulasan.dart';
import 'package:provider/provider.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({
    Key? key,
    required this.idShop,
    required this.idProduct,
  }) : super(key: key);

  final int idShop;
  final int idProduct;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  @override
  void initState() {
    super.initState();
    DMethod.log('SELECTED ID : ${widget.idProduct}');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _fetchData();
    });
  }

  Future<void> _fetchData() async {
    try {
      await context.read<CustomerProductDetailProvider>().fetchData(
            idShop: widget.idShop,
            idProduct: widget.idProduct,
          );
    } catch (ex) {
      Fluttertoast.showToast(msg: PasarAjaConstant.unknownError);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
      body: Consumer<CustomerProductDetailProvider>(
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
            final product = provider.productDetail;
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
                          imageUrl: product.products?.photo ?? '',
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
                        _shopData(product.shopData ?? const ShopDataModel()),
                        const SizedBox(height: 10),
                        _showReview(product.reviews ?? const RatingModel()),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return const SomethingWrong();
        },
      ),
      floatingActionButton: Consumer<CustomerProductDetailProvider>(
        builder: (context, provider, child) {
          return FloatingActionButton(
            onPressed: () {
              _showSheet(
                  provider.productDetail.products ?? const ProductModel());
            },
            backgroundColor: PasarAjaColor.green1,
            child: const Icon(
              Icons.add_shopping_cart_outlined,
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }

  _productInfo(ProductDetailModel product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.products?.productName ?? 'Null',
          style: PasarAjaTypography.sfpdBold.copyWith(
            fontSize: 30,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          "${product.products?.categoryName}",
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
            if ((product.products?.totalReview! ?? 0) > 0)
              Row(
                children: [
                  Text(
                    '${product.products?.rating}',
                    style: PasarAjaTypography.sfpdSemibold,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    "(${product.products?.totalReview})",
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
              '${product.products?.totalSold} terjual',
              style: PasarAjaTypography.sfpdSemibold,
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          (product.products?.settings?.isAvailable ?? false)
              ? 'Stok Tersedia'
              : 'Stok Tidak Tersedia',
          style: PasarAjaTypography.sfpdSemibold,
        ),
        const SizedBox(height: 5),
        Text(
          "${PasarAjaUtils.formatPrice(product.products?.price ?? 0)} / ${product.products?.sellingUnit} ${product.products?.unit}",
          style: PasarAjaTypography.sfpdRegular.copyWith(fontSize: 25),
        ),
        const SizedBox(height: 10),
        Text(
          product.products?.description ?? '',
          style: PasarAjaTypography.sfpdRegular,
        ),
      ],
    );
  }

  _shopData(ShopDataModel shopData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
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
                  imageUrl: shopData.photo ?? '',
                  placeholder: (context, str) {
                    return const ImageNetworkPlaceholder();
                  },
                  errorWidget: (context, str, obj) {
                    return const ImageErrorNetwork();
                  },
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  shopData.shopName ?? 'null',
                  style: PasarAjaTypography.sfpdSemibold.copyWith(fontSize: 16),
                ),
                const SizedBox(width: 10),
                Text(
                  shopData.benchmark ?? 'null',
                  maxLines: 2,
                  style: PasarAjaTypography.sfpdSemibold.copyWith(fontSize: 15),
                ),
                const SizedBox(width: 10),
                Text(
                  '+${shopData.phoneNumber}',
                  style: PasarAjaTypography.sfpdRegular.copyWith(fontSize: 15),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "${shopData.totalProduct} produk",
              style: PasarAjaTypography.sfpdSemibold,
            ),
            const SizedBox(width: 5),
            Text(
              "-",
              style: PasarAjaTypography.sfpdSemibold,
            ),
            const SizedBox(width: 5),
            Text(
              "${shopData.totalSold} terjual",
              style: PasarAjaTypography.sfpdSemibold,
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }

  _showReview(RatingModel reviews) {
    // return Text('${reviews.reviewers?.length}');
    return ListView.builder(
      shrinkWrap: true,
      itemCount: reviews.reviewers?.length,
      itemBuilder: (context, index) {
        var rvwModel = reviews.reviewers?[index];
        DMethod.log('name : ${rvwModel?.fullName ?? 'null'}');
        return ItemUlasan(
          review: rvwModel ?? const ReviewModel(),
        );
      },
    );
  }

  _showSheet(ProductModel product) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return Consumer<CustomerProductDetailProvider>(
          builder: (context, provider, child) {
            provider.priceSelected = product.price ?? 0;
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.productName ?? 'null',
                    maxLines: 2,
                    style:
                        PasarAjaTypography.sfpdSemibold.copyWith(fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "${PasarAjaUtils.formatPrice(product.price ?? 0)} / ${product.sellingUnit} ${product.unit}",
                        style: PasarAjaTypography.sfpdRegular
                            .copyWith(fontSize: 25),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(width: 10),
                          IconButton(
                              onPressed: () {
                                provider.quantity = --provider.quantity;
                              },
                              icon: const Icon(Icons.exposure_minus_1)),
                          // Add TextField here
                          Expanded(
                            child: TextField(
                              controller: provider.quantityCont,
                              readOnly: true,
                              decoration: const InputDecoration(
                                hintText: '0',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                provider.quantity = ++provider.quantity;
                              },
                              icon: const Icon(Icons.exposure_plus_1_outlined)),
                          Text(
                            "(${PasarAjaUtils.formatPrice(provider.price ?? 0)})",
                            style: PasarAjaTypography.sfpdRegular
                                .copyWith(fontSize: 25),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  ActionButton(onPressed: (){
                    context.read<CustomerProductDetailProvider>().onButtonAddCartPressed();
                  }, title: 'Masukan Keranjang', state: ActionButton.stateEnabledButton,),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
