import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/widgets/loading_indicator.dart';
import 'package:pasaraja_mobile/config/widgets/merchant_sub_appbar.dart';
import 'package:pasaraja_mobile/config/widgets/page_error_message.dart';
import 'package:pasaraja_mobile/config/widgets/something_wrong.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/module/merchant/providers/product/detail_list_provider.dart';
import 'package:pasaraja_mobile/module/merchant/widgets/item_complain.dart';
import 'package:pasaraja_mobile/module/merchant/widgets/item_history.dart';
import 'package:pasaraja_mobile/module/merchant/widgets/item_ulasan.dart';
import 'package:provider/provider.dart';

class DetailListPage extends StatefulWidget {
  const DetailListPage({
    super.key,
    required this.title,
    required this.type,
    required this.idProduct,
  });

  final String title;
  final int type;
  final int idProduct;
  // type of list
  static int listReview = 1;
  static int listComplain = 2;
  static int listHistory = 3;

  @override
  State<DetailListPage> createState() => DetailListPageState();
}

class DetailListPageState extends State<DetailListPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _fetchData(context);
    });
    super.initState();
  }

  Future<void> _fetchData(BuildContext context) async {
    DMethod.log('id prod : ${widget.idProduct}');
    switch (widget.type) {
      case 1:
        Provider.of<DetailListProvider>(context, listen: false)
            .fetchDataReview(
          idProduct: widget.idProduct,
        );
      case 2:
        Provider.of<DetailListProvider>(context, listen: false)
            .fetchDataComplain(
          idProduct: widget.idProduct,
        );
      case 3:
        Provider.of<DetailListProvider>(context, listen: false)
            .fetchDataHistory(
          idProduct: widget.idProduct,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: merchantSubAppbar(widget.title),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    switch (widget.type) {
      case 1:
        return _listOfReviews();
      case 2:
        return _listOfComplains();
      case 3:
        return _listOfHistories();
    }
    return Container();
  }

  Widget _listOfReviews() {
    return Consumer<DetailListProvider>(
      builder: (context, value, child) {
        if (value.state is OnLoadingState) {
          return const LoadingIndicator();
        }

        if (value.state is OnSuccessState) {
          return SingleChildScrollView(
            child: Column(
              children: [
                if (value.reviews.isNotEmpty)
                  ...value.reviews.map(
                    (e) => ItemUlasan(
                      review: e,
                      showProduct: false,
                    ),
                  )
              ],
            ),
          );
        }

        if (value.state is OnFailureState) {
          return PageErrorMessage(
            onFailureState: value.state as OnFailureState,
          );
        }

        return const SomethingWrong();
      },
    );
  }

  Widget _listOfComplains() {
    return Consumer<DetailListProvider>(
      builder: (context, value, child) {
        if (value.state is OnLoadingState) {
          return const LoadingIndicator();
        }

        if (value.state is OnSuccessState) {
          return SingleChildScrollView(
            child: Column(
              children: [
                if (value.complains.isNotEmpty)
                  ...value.complains.map(
                    (e) => ItemComplain(
                      complain: e,
                    ),
                  )
              ],
            ),
          );
        }

        if (value.state is OnFailureState) {
          return PageErrorMessage(
            onFailureState: value.state as OnFailureState,
          );
        }

        return const SomethingWrong();
      },
    );
  }

  Widget _listOfHistories() {
    return Consumer<DetailListProvider>(
      builder: (context, value, child) {
        if (value.state is OnLoadingState) {
          return const LoadingIndicator();
        }

        if (value.state is OnSuccessState) {
          return SingleChildScrollView(
            child: Column(
              children: [
                if (value.history.isNotEmpty)
                  ...value.history.map(
                    (e) => ItemHistory(
                      history: e,
                    ),
                  )
              ],
            ),
          );
        }

        if (value.state is OnFailureState) {
          return PageErrorMessage(
            onFailureState: value.state as OnFailureState,
          );
        }

        return const SomethingWrong();
      },
    );
  }
}
