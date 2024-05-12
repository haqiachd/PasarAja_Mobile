import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/services/user_services.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/core/utils/messages.dart';
import 'package:pasaraja_mobile/module/auth/widgets/widgets.dart';
import 'package:pasaraja_mobile/module/customer/controllers/order_controller.dart';
import 'package:pasaraja_mobile/module/customer/models/transaction_detail_history_model.dart';
import 'package:pasaraja_mobile/module/customer/provider/order/order_finished_provider.dart';
import 'package:pasaraja_mobile/module/customer/views/order/order_detail_page.dart';

class OrderComplainProvider extends ChangeNotifier {
  TextEditingController namaCont = TextEditingController();
  TextEditingController reasonCont = TextEditingController();
  final _controller = OrderController();

  ProviderState state = const OnInitState();

  TransactionDetailHistoryModel _prod = const TransactionDetailHistoryModel();
  TransactionDetailHistoryModel get prod => _prod;

  int _idComplain = 0;
  int _idTrx = 0;
  int _idUser = 0;
  int _idShop = 0;
  int _idProduct = 0;
  String _orderCode = '';
  bool _isEdit = false;

  int _buttonState = AuthFilledButton.stateDisabledButton;
  int get buttonState => _buttonState;
  set buttonState(int btn) {
    _buttonState = btn;
    notifyListeners();
  }

  void validateReason() {
    int index = reasonCont.text.length;

    if (index <= 0 || reasonCont.text.trim().isEmpty) {
      _buttonState = AuthFilledButton.stateDisabledButton;
    } else {
      _buttonState = AuthFilledButton.stateEnabledButton;
    }

    notifyListeners();
  }

  Future<void> onInit({
    required TransactionDetailHistoryModel prod,
    required bool isEdit,
    int? idTrx,
    String? orderCode,
  }) async {
    try {
      namaCont.text = '';
      reasonCont.text = '';
      state = const OnLoadingState();
      _prod = prod;
      _isEdit = isEdit;
      notifyListeners();

      _idUser = await PasarAjaUserService.getUserId();
      namaCont.text =  "${prod.quantity} x ${prod.product?.productName}";
      _idShop = prod.product!.idShop!;
      _idProduct = prod.product!.id!;
      if (isEdit) {
        _buttonState = AuthFilledButton.stateEnabledButton;
        _idTrx = idTrx!;
        _idComplain = prod.complain!.idComplain!;
        reasonCont.text = prod.complain!.reason!;
      } else {
        _buttonState = AuthFilledButton.stateDisabledButton;
        _orderCode = orderCode!;
      }

      state = const OnSuccessState();
      notifyListeners();
    } catch (ex) {
      DMethod.log('error : $ex');
      state = OnFailureState(message: ex.toString());
      notifyListeners();
    }
  }

  Future<void> onSaveButtonPressed() async {
    try {
      _buttonState = AuthFilledButton.stateLoadingButton;
      notifyListeners();

      reasonCont.text = reasonCont.text.replaceAll('\n', ' ');
      if (!_isEdit) {
        DMethod.log('id user : $_idUser');
        DMethod.log('order code : $_orderCode');
        DMethod.log('id shop : $_idShop');
        DMethod.log('id product : $_idProduct');
        DMethod.log('alasan : ${reasonCont.text}');

        // save complain
        final compTrx = await _controller.writeComplain(
          orderCode: _orderCode,
          idUser: _idUser,
          idShop: _idShop,
          idProduct: _idProduct,
          reason: reasonCont.text,
        );

        if (compTrx is DataSuccess) {
          _buttonState = AuthFilledButton.stateEnabledButton;
          notifyListeners();
          await PasarAjaMessage.showInformation('Komplain Berhasil Terkirim');
          Get.off(
            OrderDetailPage(
              orderCode: _orderCode,
              provider: CustomerOrderFinishedProvider(),
            ),
            transition: Transition.rightToLeft,
          );
        }

        if (compTrx is DataFailed) {
          PasarAjaMessage.showSnackbarWarning(
            compTrx.error?.error.toString() ?? PasarAjaConstant.unknownError,
          );
        }
      } else {
        DMethod.log('id user : $_idUser');
        DMethod.log('id trx: $_idTrx');
        DMethod.log('id complain : $_idComplain');
        DMethod.log('id shop : $_idShop');
        DMethod.log('id product : $_idProduct');
        DMethod.log('alasan : ${reasonCont.text}');

        // edit complain
        final compTrx = await _controller.updateComplain(
          idTrx: _idTrx,
          idComplain: _idComplain,
          idShop: _idShop,
          idProduct: _idProduct,
          reason: reasonCont.text,
        );

        if (compTrx is DataSuccess) {
          _buttonState = AuthFilledButton.stateEnabledButton;
          notifyListeners();
          await PasarAjaMessage.showInformation('Komplain Berhasil Diupdate');
          Get.off(
            OrderDetailPage(
              orderCode: _orderCode,
              provider: CustomerOrderFinishedProvider(),
            ),
            transition: Transition.rightToLeft,
          );
        }

        if (compTrx is DataFailed) {
          PasarAjaMessage.showSnackbarWarning(
            compTrx.error?.error.toString() ?? PasarAjaConstant.unknownError,
          );
        }
      }

      _buttonState = AuthFilledButton.stateEnabledButton;
      notifyListeners();
    } catch (ex) {
      DMethod.log('error : $ex');
      PasarAjaMessage.showSnackbarWarning(ex.toString());
    }
  }
}
