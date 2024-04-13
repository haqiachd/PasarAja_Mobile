import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pasaraja_mobile/config/widgets/app_input_text.dart';
import 'package:pasaraja_mobile/config/widgets/app_textfield.dart';
import 'package:pasaraja_mobile/config/widgets/merchant_sub_appbar.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';

class AddPromoPage extends StatefulWidget {
  const AddPromoPage({
    super.key,
    required this.idProduct,
    required this.productName,
    required this.productPrice,
  });

  final int idProduct;
  final String productName;
  final int productPrice;

  @override
  State<AddPromoPage> createState() => _AddPromoPageState();
}

class _AddPromoPageState extends State<AddPromoPage> {
  TextEditingController nameProd = TextEditingController();
  TextEditingController hrgProd = TextEditingController();
  TextEditingController startDate = TextEditingController();
  TextEditingController _hrgPromo = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameProd = TextEditingController(text: widget.productName);
    hrgProd = TextEditingController(text: "Rp. ${PasarAjaUtils.formatPrice(widget.productPrice)}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: merchantSubAppbar("Tambah Promo"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              const SizedBox(height: 50),
              AppInputText(
                title: "Nama Produk",
                textField: AppTextField(
                  controller: nameProd,
                  suffixIcon: const Material(),
                  readOnly: true,
                ),
              ),
              const SizedBox(height: 20),
              AppInputText(
                title: "Harga Produk",
                textField: AppTextField(
                  controller: hrgProd,
                  suffixIcon: const Material(),
                  readOnly: true,
                ),
              ),
              const SizedBox(height: 20),
              AppInputText(
                title: "Masukan Harga Promo",
                textField: AppTextField(
                  controller: _hrgPromo,
                  keyboardType: TextInputType.number,
                  formatters: AppTextField.numberFormatter(),
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: (){
                  _selectDate(context);
                },
                child: AbsorbPointer(
                  child: AppTextField(
                    hintText: 'Masukan Tanggal Awal',
                    controller: startDate,
                    suffixIcon: const Icon(Icons.calendar_today),
                    readOnly: true,
                  ),
                ),
              )
              // tambahkan input untuk date time
              // tambahkan input untuk date time
            ],
          ),
        ),
      ),
    );
  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime today = DateTime.now();
    final DateTime fiveMonthsFromNow = today.add(const Duration(days: 5 * 30));
    // show data picker
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: today.add(const Duration(days: 1)),
      firstDate: today.add(const Duration(days: 1)),
      selectableDayPredicate: (DateTime date) {
        if (date.year < today.year ||
            (date.year == today.year && date.month < today.month) ||
            (date.year == today.year && date.month == today.month && date.day <= today.day)) {
          return false;
        }
        return true;
      },
      lastDate: fiveMonthsFromNow,
    );

    // jika user memilih tanggal
    if (pickedDate != null) {
      startDate.text = DateFormat.yMd().format(pickedDate);
    }
  }
}


