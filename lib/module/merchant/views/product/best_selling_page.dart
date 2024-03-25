import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pasaraja_mobile/config/widgets/loading_indicator.dart';
import 'package:pasaraja_mobile/config/widgets/merchant_sub_appbar.dart';
import 'package:pasaraja_mobile/config/widgets/page_error_message.dart';
import 'package:pasaraja_mobile/config/widgets/something_wrong.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/module/merchant/providers/product/best_selling_provider.dart';
import 'package:pasaraja_mobile/module/merchant/widgets/item_best_selling.dart';
import 'package:provider/provider.dart';

class BestSellingPage extends StatefulWidget {
  const BestSellingPage({super.key});

  @override
  State<BestSellingPage> createState() => _BestSellingPageState();
}

class _BestSellingPageState extends State<BestSellingPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _fetchData();
    });
    super.initState();
  }

  Future<void> _fetchData() async {
    try {
      await Provider.of<BestSellingProvider>(
        context,
        listen: false,
      ).fetchData();
    } catch (ex) {
      Fluttertoast.showToast(msg: PasarAjaConstant.unknownError);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: merchantSubAppbar('Produk Terlaris'),
      body: RefreshIndicator(
        color: Colors.black,
        onRefresh: () async {
          await PasarAjaConstant.onRefreshDelay;
          _fetchData();
        },
        // MENDAPATKAN DATA
        child: Consumer<BestSellingProvider>(
          builder: (context, value, child) {
            // menampilkan loading
            if (value.state is OnLoadingState) {
              return const LoadingIndicator();
            }

            // jika error
            if (value.state is OnFailureState) {
              return PageErrorMessage(
                onFailureState: value.state as OnFailureState,
              );
            }

            // berhasil
            if (value.state is OnSuccessState) {
              return Padding(
                padding: const EdgeInsets.all(10),
                child: ListView.builder(
                  itemCount: value.bestSelling.length,
                  itemBuilder: (context, index) {
                    final product = value.bestSelling[index];
                    DMethod.log('prod name : ${product.productName}');
                    return ItemBestSelling(product: product);
                  },
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
