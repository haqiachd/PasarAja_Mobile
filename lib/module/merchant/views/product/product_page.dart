import 'package:cached_network_image/cached_network_image.dart';
import 'package:d_method/d_method.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/images.dart';
import 'package:pasaraja_mobile/config/widgets/app_bar.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/module/merchant/models/product/product_page_model.dart';
import 'package:pasaraja_mobile/module/merchant/models/product_category_model.dart';
import 'package:pasaraja_mobile/module/merchant/providers/product/product_provider.dart';
import 'package:pasaraja_mobile/module/merchant/widgets/category_item.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _fetchData();
    });
    super.initState();
  }

  Future<void> _fetchData() async {
    try {
      DMethod.log('fetch api data');
      await Provider.of<ProductProvider>(
        context,
        listen: false,
      ).fetchData();
    } catch (ex) {
      Fluttertoast.showToast(msg: "Sometimes Wrong : ${ex.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PasarAjaColor.white,
      body: Stack(
        children: [
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: PasarAjaAppbar(
              title: 'Produk',
            ),
          ),
          Positioned(
            top: 97,
            bottom: 0,
            left: 0,
            right: 0,
            child: RefreshIndicator(
              onRefresh: _fetchData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Consumer<ProductProvider>(
                  builder: (context, value, child) {
                    // show loading
                    if (value.state is OnLoadingState) {
                      return const Center(
                        child: CupertinoActivityIndicator(),
                      );
                    }

                    // jika data berhasil didapakan
// Jika data berhasil didapatkan
                    if (value.state is OnSuccessState) {
                      List<ProductCategoryModel> categories = value.categories;

                      return SizedBox(
                        height: 300,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(5),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    child: CachedNetworkImage(
                                      imageUrl: categories[index].photo ?? '',
                                      placeholder: (context, url) {
                                        return Image.asset(
                                            PasarAjaImage.icGoogle);
                                      },
                                      errorWidget: (context, url, error) {
                                        return Text('error');
                                      },
                                    ),
                                  ),
                                  Text(categories[index].categoryName ?? 'nul'),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    }

                    // jika data gagal didapatkan
                    if (value.state is OnFailureState) {
                      return const Center(
                        child: Text('Failure'),
                      );
                    }

                    return const Center(
                      child: Text('Sometimes Wrong'),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
