import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pasaraja_mobile/config/widgets/action_button.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/services/user_services.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/utils/messages.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
import 'package:pasaraja_mobile/core/utils/validations.dart';
import 'package:pasaraja_mobile/module/merchant/controllers/promo_controller.dart';
import 'package:pasaraja_mobile/module/merchant/models/promo_model.dart';

class EditPromoProvider extends ChangeNotifier {
// controller, validatoion
  final _controller = PromoController();
  TextEditingController hrgPromoCont = TextEditingController();
  TextEditingController startDateCont = TextEditingController();
  TextEditingController endDateCont = TextEditingController();
  ValidationModel vPromo = PasarAjaValidation.promoPrice(null, null);
  ValidationModel vStartDate = PasarAjaValidation.startDate(null);
  ValidationModel vEndDate = PasarAjaValidation.endDate(null, null);
  DateTime _startDate = DateTime.now();

  // button state status
  int _buttonState = ActionButton.stateDisabledButton;

  int get buttonState => _buttonState;

  set buttonState(int n) {
    _buttonState = n;
    notifyListeners();
  }

  Object _message = '';

  Object get message => _message;

  set message(Object m) {
    _message = m;
    notifyListeners();
  }

  bool _isSelectedStart = false;

  bool get isSelectedStart => _isSelectedStart;

  /// Untuk mengecek apakah promo yang diinputkan valid atau tidak
  ///
  void onValidatePrice(String price, String promoPrice) {
    // mengecek apakah password valid atau tidak
    vPromo = PasarAjaValidation.promoPrice(price, promoPrice);

    // jika password valid
    if (vPromo.status == true) {
      _message = '';
    } else {
      _message = vPromo.message ?? PasarAjaConstant.unknownError;
    }

    // update status button
    _updateButtonState();
  }

  /// Untuk mengecek apakah startdate yang diinputkan valid atau tidak
  ///
  void onValidateStartDate(String startDate) {
    // mengecek apakah start date valid atau tidak
    vStartDate = PasarAjaValidation.startDate(startDate);

    // jika start date valid
    if (vStartDate.status == true) {
      _message = '';
    } else {
      _message = vStartDate.message ?? PasarAjaConstant.unknownError;
    }

    // update status button
    _updateButtonState();
  }

  /// Untuk mengecek apakah enddate yang diinputkan valid atau tidak
  ///
  void onValidateEndDate(String endDate) {
    // mengecek apakah end date valid atau tidak
    vEndDate = PasarAjaValidation.endDate(startDateCont.text, endDate);

    // jika end date valid
    if (vEndDate.status == true) {
      _message = '';
    } else {
      _message = vEndDate.message ?? PasarAjaConstant.unknownError;
    }

    // update status button
    _updateButtonState();
  }

  /// Enable & disable button, sesuai dengan valid atau tidaknya data
  ///
  void _updateButtonState() {
    if (vPromo.status == null ||
        vStartDate.status == null ||
        vEndDate.status == null) {
      _buttonState = ActionButton.stateDisabledButton;
    }
    if (vPromo.status == false ||
        vStartDate.status == false ||
        vEndDate.status == false) {
      _buttonState = ActionButton.stateDisabledButton;
    } else {
      _buttonState = ActionButton.stateEnabledButton;
    }
    notifyListeners();
  }

  //
  Future<void> selectStartDate(BuildContext context) async {
    final DateTime today = DateTime.now();
    final DateTime fiveMonthsFromNow = today.add(const Duration(days: 5 * 30));
    DateTime initDate = DateTime.now();

    // inisilisasi init date
    try {
      initDate = DateTime.parse(startDateCont.text);
    } catch (ex) {
      initDate = DateTime.now();
    }

    // show date picker
    final DateTime? pickedDate = await showDatePicker(
      helpText: 'Pilih Tanggal Mulai Promo',
      context: context,
      initialDate: initDate,
      firstDate: _startDate,
      lastDate: fiveMonthsFromNow,
      selectableDayPredicate: (DateTime date) {
        if ((date.month == _startDate.month &&
            (date.day > _startDate.day && date.day < DateTime.now().day))) {
          return false;
        }
        // Nonaktifkan hari Minggu
        // if (date.weekday == DateTime.sunday) {
        //   return false;
        // }
        // Nonaktifkan tanggal sebelum hari ini
        // if (date.isBefore(today)) {
        //   return false;
        // }
        return true;
      },
      confirmText: "Pilih",
      cancelText: "Batal",
    );

    // jika user memilih tanggal
    if (pickedDate != null) {
      // Format tanggal sesuai dengan kebutuhan (yyyy-MM-dd)
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      startDateCont.text = formattedDate;
      _isSelectedStart = true;

      try {
        // inisialisasi date untuk validasi data tanggal
        DateTime startDate =
            DateTime.parse(startDateCont.text).add(const Duration(days: 1));
        DateTime endDate = DateTime.parse(endDateCont.text);
        DateTime sixMonthsFromNow = startDate.add(const Duration(days: 6 * 30));

        // handler jika tanggal akhir dari batas tanggal akhir promo (6 bulan)
        if (endDate.isAfter(sixMonthsFromNow)) {
          endDate = sixMonthsFromNow;
          endDateCont.text = DateFormat('yyyy-MM-dd').format(endDate);
        }

        // handler jika tanggal akhir kurang dari tanggal awal
        if (endDate.isBefore(startDate)) {
          endDate = startDate;
          endDateCont.text = DateFormat('yyyy-MM-dd').format(endDate);
        }
      } catch (ex) {
        notifyListeners();
      }
    }
  }

  Future<void> selectEndDate(BuildContext context) async {
    final DateTime firstDate =
        DateTime.parse(startDateCont.text).add(const Duration(days: 1));
    final DateTime sixMonthsFromNow =
        firstDate.add(const Duration(days: 6 * 30));

    DateTime initDate = firstDate;

    try {
      initDate = DateTime.parse(endDateCont.text);
    } catch (ex) {
      initDate = firstDate;
    }

    // show date picker
    final DateTime? pickedDate = await showDatePicker(
      helpText: 'Pilih Tanggal Akhir Promo',
      context: context,
      initialDate: initDate,
      firstDate: firstDate,
      lastDate: sixMonthsFromNow,
      selectableDayPredicate: (DateTime date) {
        if ((date.month == _startDate.month &&
            (date.day > _startDate.day && date.day < DateTime.now().day))) {
          return false;
        }
        // // Nonaktifkan hari Minggu
        // if (date.weekday == DateTime.sunday) {
        //   return false;
        // }
        // Nonaktifkan tanggal sebelum hari ini
        // if (date.isBefore(today)) {
        //   return false;
        // }
        return true;
      },
      confirmText: "Pilih",
      cancelText: "Batal",
    );

    // jika user memilih tanggal
    if (pickedDate != null) {
      // Format tanggal sesuai dengan kebutuhan (yyyy-MM-dd)
      endDateCont.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      notifyListeners();
    }
  }

  Future<void> onEditButtonPressed({
    required int idPromo,
  }) async {
    try {
      // show loading button
      buttonState = ActionButton.stateLoadingButton;

      // get id shop
      final idShop = await PasarAjaUserService.getShopId();

      // call controller
      final dataState = await _controller.updatePromo(
        idShop: idShop,
        idPromo: idPromo,
        promoPrice: int.parse(hrgPromoCont.text),
        startDate: DateTime.parse(startDateCont.text),
        endDate: DateTime.parse(endDateCont.text),
      );

      DMethod.log("ID SHOP : $idShop");
      DMethod.log("ID PROMO : $idPromo");
      DMethod.log("PROMO PRICE : ${hrgPromoCont.text}");
      DMethod.log("START DATE : ${startDateCont.text}");
      DMethod.log("END DATE : ${endDateCont.text}");

      // jika promo berhasil diubah
      if (dataState is DataSuccess) {
        // close loading button
        buttonState = ActionButton.stateEnabledButton;

        // menampilkan dialog informasi, bahwa promo berhasil diubah
        await PasarAjaMessage.showInformation(
          'Promo Berhasil Diupdate',
          actionYes: 'OK',
        );

        // kembali ke halaman welcome
        Get.back();
        Get.back();
      }

      // jika promo gagal diubah
      if (dataState is DataFailed) {
        PasarAjaUtils.triggerVibration();
        Fluttertoast.showToast(
          msg: dataState.error!.error.toString(),
        );
      }

      // close loading button
      buttonState = ActionButton.stateEnabledButton;
    } catch (ex) {
      _buttonState = ActionButton.stateEnabledButton;
      _message = ex.toString();
      notifyListeners();
      Fluttertoast.showToast(msg: message.toString());
    }
  }

  Future<void> setData({
    required PromoModel promo,
  }) async {
    startDateCont.text = promo.startDate?.toIso8601String().substring(0, 10) ??
        DateFormat('yyyy-MM-dd').format(DateTime.now());
    _startDate = DateTime.parse(startDateCont.text);
    endDateCont.text = promo.endDate?.toIso8601String().substring(0, 10) ?? '';
    hrgPromoCont.text = promo.promoPrice.toString();
    _isSelectedStart = true;
    vPromo = PasarAjaValidation.promoPrice(
        promo.price.toString(), hrgPromoCont.text);
    vStartDate = PasarAjaValidation.startDate(startDateCont.text);
    vEndDate = PasarAjaValidation.endDate(startDateCont.text, endDateCont.text);
    buttonState = ActionButton.stateEnabledButton;
    notifyListeners();
    DMethod.log('start date : ${startDateCont.text}');
    DMethod.log('end date : ${endDateCont.text}');
  }
}
