import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pasaraja_mobile/config/widgets/loading_indicator.dart';
import 'package:pasaraja_mobile/config/widgets/page_error_message.dart';
import 'package:pasaraja_mobile/config/widgets/something_wrong.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/module/customer/provider/providers.dart';
import 'package:pasaraja_mobile/module/customer/widgets/customer_sub_appbar.dart';
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
      appBar: customerSubAppbar('Detail Produk'),
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
            return const Center(
              child: Text('Data Detail Produk'),
            );
          }

          return const SomethingWrong();
        },
      ),
    );
  }
}
