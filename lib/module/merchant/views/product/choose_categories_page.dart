import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/config/widgets/loading_indicator.dart';
import 'package:pasaraja_mobile/config/widgets/merchant_sub_appbar.dart';
import 'package:pasaraja_mobile/config/widgets/page_error_message.dart';
import 'package:pasaraja_mobile/config/widgets/something_wrong.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/module/merchant/models/product/choose_categories_model.dart';
import 'package:pasaraja_mobile/module/merchant/providers/product/choose_categories_provider.dart';
import 'package:pasaraja_mobile/module/merchant/views/product/add_product_page.dart';
import 'package:pasaraja_mobile/module/merchant/widgets/choose_category_list.dart';
import 'package:provider/provider.dart';

class ChooseCategoriesPage extends StatefulWidget {
  const ChooseCategoriesPage({super.key});

  @override
  State<ChooseCategoriesPage> createState() => _ChooseCategoriesPageState();
}

class _ChooseCategoriesPageState extends State<ChooseCategoriesPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await Provider.of<ChooseCategoriesProvider>(
          context,
          listen: false,
        ).fetchData();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: merchantSubAppbar('Pilih Kategori'),
      body: Consumer<ChooseCategoriesProvider>(
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
            final List<ChooseCategoriesModel> categories = value.categories;
            return SingleChildScrollView(
              child: Column(
                children: categories
                    .map(
                      (e) => ChooseCategory(
                        category: e,
                        onTap: () {
                          Get.to(
                            AddProductPage(
                              idCategory: e.idCategory,
                              categoryName: e.categoryName,
                            ),
                            transition: Transition.cupertino,
                          );
                        },
                      ),
                    )
                    .toList(),
              ),
            );
          }

          return const SomethingWrong();
        },
      ),
    );
  }
}
