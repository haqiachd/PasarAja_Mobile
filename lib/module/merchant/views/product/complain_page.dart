import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pasaraja_mobile/config/widgets/loading_indicator.dart';
import 'package:pasaraja_mobile/config/widgets/merchant_sub_appbar.dart';
import 'package:pasaraja_mobile/config/widgets/page_error_message.dart';
import 'package:pasaraja_mobile/config/widgets/something_wrong.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/module/merchant/providers/product/complain_provider.dart';
import 'package:pasaraja_mobile/module/merchant/widgets/item_complain.dart';
import 'package:provider/provider.dart';

class ComplainPage extends StatefulWidget {
  const ComplainPage({super.key});

  @override
  State<ComplainPage> createState() => ComplainPageState();
}

class ComplainPageState extends State<ComplainPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _fetchData();
    });
    super.initState();
  }

  Future<void> _fetchData() async {
    try {
      await Provider.of<ComplainProvider>(
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
      appBar: merchantSubAppbar('Komplain Pembeli'),
      body: RefreshIndicator(
        onRefresh: () async {
          await PasarAjaConstant.onRefreshDelay;
          _fetchData();
        },
        // MENDAPATKAN DATA
        child: Consumer<ComplainProvider>(
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
              return ListView.builder(
                itemCount: value.complains.length,
                itemBuilder: (context, index) {
                  return ItemComplain(
                    complain: value.complains[index],
                  );
                },
              );
            }

            return const SomethingWrong();
          },
        ),
      ),
    );
  }
}
