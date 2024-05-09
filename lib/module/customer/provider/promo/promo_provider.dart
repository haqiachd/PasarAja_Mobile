import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
import 'package:pasaraja_mobile/module/customer/controllers/page_controller.dart';
import 'package:pasaraja_mobile/module/customer/models/page/promo_page_model.dart';
import 'package:pasaraja_mobile/module/customer/models/product_model.dart';
import 'package:pasaraja_mobile/module/merchant/models/product_category_model.dart';

class CustomerPromoProvider extends ChangeNotifier {
  ProviderState state = const OnInitState();

  final _pageCont = CustomerPageController();

  PromoPageModel _promoPage = const PromoPageModel();

  PromoPageModel get promoPage => _promoPage;

  List<ProductCategoryModel> _categories = [];
  List<ProductCategoryModel> get categories => _categories;

  List<ProductModel> _products = [];
  List<ProductModel> get products => _products;

  Future<void> fetchData() async {
    try {
      state = OnLoadingState();
      notifyListeners();
      _products = [];
      _categories = [];

      final dataState = await _pageCont.promoData();

      if (dataState is DataSuccess) {
        state = OnSuccessState();
        notifyListeners();
        _promoPage = dataState.data as PromoPageModel;
        _categories = _promoPage.categories!;

        for(var prod in _promoPage.products!){
          if(PasarAjaUtils.isActivePromo(prod.promo!)){
            _products.add(prod);
          }
        }
        notifyListeners();
      }

      if (dataState is DataFailed) {
        state = OnFailureState(message: dataState.error!.error?.toString());
        notifyListeners();
      }
    } catch (ex) {
      state = OnFailureState(message: ex.toString());
      notifyListeners();
      Fluttertoast.showToast(msg: ex.toString());
    }
  }
}
