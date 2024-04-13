import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:pasaraja_mobile/config/widgets/action_button.dart';
import 'package:pasaraja_mobile/config/widgets/app_input_text.dart';
import 'package:pasaraja_mobile/config/widgets/app_textfield.dart';
import 'package:pasaraja_mobile/config/widgets/merchant_sub_appbar.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
import 'package:pasaraja_mobile/module/merchant/providers/promo/add_promo_provider.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    super.initState();
    nameProd = TextEditingController(text: widget.productName);
    hrgProd = TextEditingController(
      text: "Rp. ${PasarAjaUtils.formatPrice(widget.productPrice)}",
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<AddPromoProvider>().resetData();
    });
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
              _buildInputNamaProd(),
              const SizedBox(height: 20),
              _buildInputHarga(),
              const SizedBox(height: 20),
              _buildHargaPromo(),
              const SizedBox(height: 20),
              _buildStartDate(context),
              const SizedBox(height: 20),
              _buildEndDate(context),
              const SizedBox(height: 60),
              _buildButtonAdd(),
            ],
          ),
        ),
      ),
    );
  }

  AppInputText _buildInputNamaProd() {
    return AppInputText(
      title: "Nama Produk",
      textField: AppTextField(
        controller: nameProd,
        fontSize: 21,
        suffixIcon: const Material(),
        readOnly: true,
      ),
    );
  }

  AppInputText _buildInputHarga() {
    return AppInputText(
      title: "Harga Produk",
      textField: AppTextField(
        controller: hrgProd,
        fontSize: 21,
        suffixIcon: const Material(),
        readOnly: true,
      ),
    );
  }

  _buildHargaPromo() {
    return Consumer<AddPromoProvider>(
      builder: (context, provider, child) {
        // cont
        final hrgPromoCont = provider.hrgPromoCont;
        return AppInputText(
          title: "Masukan Harga Promo",
          textField: AppTextField(
            controller: hrgPromoCont,
            errorText: provider.vPromo.message,
            keyboardType: TextInputType.number,
            hintText: 'Masukan Harga Promo',
            fontSize: 21,
            formatters: AppTextField.numberFormatter(),
            onChanged: (value) {
              provider.onValidatePrice(
                widget.productPrice.toString(),
                value,
              );
            },
            suffixAction: () {
              provider.hrgPromoCont.text = '';
              provider.onValidatePrice('', '');
              provider.buttonState = ActionButton.stateDisabledButton;
            },
          ),
        );
      },
    );
  }

  _buildStartDate(BuildContext context) {
    return Consumer<AddPromoProvider>(
      builder: (context, provider, child) {
        // cont
        final startDateCont = provider.startDateCont;
        return Padding(
          padding:
              EdgeInsets.only(right: MediaQuery.of(context).size.width / 2.5),
          child: InkWell(
            onTap: () async {
              await provider.selectStartDate(context);
              provider.onValidateStartDate(startDateCont.text);
            },
            child: AbsorbPointer(
              child: AppTextField(
                hintText: 'Tanggal Awal',
                fontSize: 21,
                controller: startDateCont,
                errorText: provider.vStartDate.message,
                suffixIcon: const Icon(Icons.calendar_today),
                readOnly: true,
              ),
            ),
          ),
        );
      },
    );
  }

  _buildEndDate(BuildContext context) {
    return Consumer<AddPromoProvider>(
      builder: (context, provider, child) {
        final endDateCont = provider.endDateCont;
        return Padding(
          padding:
              EdgeInsets.only(right: MediaQuery.of(context).size.width / 2.5),
          child: InkWell(
            onTap: () async{
              if (provider.isSelectedStart) {
                await provider.selectEndDate(context);
                provider.onValidateEndDate(endDateCont.text);
              } else {
                Fluttertoast.showToast(
                    msg: "Pilih tanggal awal terlebih dahulu");
              }
            },
            child: AbsorbPointer(
              child: AppTextField(
                hintText: 'Tanggal Akhir',
                controller: endDateCont,
                errorText: provider.vEndDate.message,
                fontSize: 21,
                suffixIcon: const Icon(Icons.calendar_today),
                readOnly: true,
              ),
            ),
          ),
        );
      },
    );
  }

  Consumer<AddPromoProvider> _buildButtonAdd() {
    return Consumer<AddPromoProvider>(
      builder: (context, provider, child) {
        return ActionButton(
          onPressed: () {
            provider.onAddButtonPressed(idProduct: widget.idProduct);
          },
          title: "Tambahkan",
          state: provider.buttonState,
        );
      },
    );
  }
}
