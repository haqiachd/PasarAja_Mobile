import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pasaraja_mobile/config/widgets/action_button.dart';
import 'package:pasaraja_mobile/config/widgets/app_input_text.dart';
import 'package:pasaraja_mobile/config/widgets/app_input_title.dart';
import 'package:pasaraja_mobile/config/widgets/app_textfield.dart';
import 'package:pasaraja_mobile/config/widgets/merchant_sub_appbar.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
import 'package:pasaraja_mobile/module/merchant/models/promo_model.dart';
import 'package:pasaraja_mobile/module/merchant/providers/promo/edit_promo_provider.dart';
import 'package:provider/provider.dart';

class EditPromoPage extends StatefulWidget {
  const EditPromoPage({
    super.key,
    required this.promo,
  });

  final PromoModel promo;

  @override
  State<EditPromoPage> createState() => _EditPromoPageState();
}

class _EditPromoPageState extends State<EditPromoPage> {
  TextEditingController nameProd = TextEditingController();
  TextEditingController hrgProd = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameProd = TextEditingController(text: widget.promo.productName);
    hrgProd = TextEditingController(
      text: "Rp. ${PasarAjaUtils.formatPrice(widget.promo.price ?? 0)}",
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<EditPromoProvider>().setData(promo: widget.promo);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: merchantSubAppbar("Edit Promo"),
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
              _buildButtonEdit(),
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
    return Consumer<EditPromoProvider>(
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
                widget.promo.price.toString(),
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
    return Consumer<EditPromoProvider>(
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
              child: AppInputText(
                title: 'Tanggal Awal Promo',
                textField: AppTextField(
                  hintText: 'Tanggal Awal',
                  fontSize: 21,
                  controller: startDateCont,
                  errorText: provider.vStartDate.message,
                  suffixIcon: const Icon(Icons.calendar_today),
                  readOnly: true,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _buildEndDate(BuildContext context) {
    return Consumer<EditPromoProvider>(
      builder: (context, provider, child) {
        final endDateCont = provider.endDateCont;
        return Padding(
          padding:
              EdgeInsets.only(right: MediaQuery.of(context).size.width / 2.5),
          child: InkWell(
            onTap: () async {
              if (provider.isSelectedStart) {
                await provider.selectEndDate(context);
                provider.onValidateEndDate(endDateCont.text);
              } else {
                Fluttertoast.showToast(
                    msg: "Pilih tanggal awal terlebih dahulu");
              }
            },
            child: AbsorbPointer(
              child: AppInputText(
                title: 'Tanggal Akhir Promo',
                textField: AppTextField(
                  hintText: 'Tanggal Akhir',
                  controller: endDateCont,
                  errorText: provider.vEndDate.message,
                  fontSize: 21,
                  suffixIcon: const Icon(Icons.calendar_today),
                  readOnly: true,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Consumer<EditPromoProvider> _buildButtonEdit() {
    return Consumer<EditPromoProvider>(
      builder: (context, provider, child) {
        return ActionButton(
          onPressed: () {
            provider.onEditButtonPressed(idPromo: widget.promo.idPromo ?? 0);
          },
          title: "Edit Promo",
          state: provider.buttonState,
        );
      },
    );
  }
}
