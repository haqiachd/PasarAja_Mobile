// ignore_for_file: unused_import

import 'dart:io';
import 'dart:typed_data';

import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pasaraja_mobile/config/widgets/app_combobox.dart';
import 'package:pasaraja_mobile/config/widgets/app_input_combobox.dart';
import 'package:pasaraja_mobile/config/widgets/app_input_text.dart';
import 'package:pasaraja_mobile/config/widgets/app_textfield.dart';
import 'package:pasaraja_mobile/config/widgets/merchant_sub_appbar.dart';
import 'package:pasaraja_mobile/core/entities/choose_photo.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/utils/messages.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
import 'package:pasaraja_mobile/core/utils/validations.dart';
import 'package:pasaraja_mobile/module/merchant/controllers/product_controller.dart';
import 'package:pasaraja_mobile/module/merchant/providers/product/add_product_provider.dart';
import 'package:pasaraja_mobile/module/merchant/widgets/action_button.dart';
import 'package:pasaraja_mobile/module/merchant/widgets/switcher_setting.dart';
import 'package:pasaraja_mobile/module/merchant/widgets/textfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({
    super.key,
    required this.idCategory,
    required this.categoryName,
  });

  final int idCategory;
  final String categoryName;

  @override
  State<AddProductPage> createState() => _DetailProductPageState();
}

class _DetailProductPageState extends State<AddProductPage> {
  TextEditingController nameCont = TextEditingController();
  TextEditingController descCont = TextEditingController();
  TextEditingController unitCont = TextEditingController();
  TextEditingController sellingCont = TextEditingController();
  TextEditingController priceCont = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<AddProductProvider>(
        context,
        listen: false,
      ).resetData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: merchantSubAppbar("Tambah Produk"),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 15),
              _buildPhotoViewer(context),
              const SizedBox(height: 15),
              _buildInputNamaProduk(),
              const SizedBox(height: 10),
              _buildInputCategory(),
              const SizedBox(height: 10),
              _buildInputDeskripsi(),
              const SizedBox(height: 10),
              _inputUnitJual(),
              const SizedBox(height: 10),
              _buildSatuanJual(),
              const SizedBox(height: 10),
              _buildInputHargaJual(),
              const SizedBox(height: 30),
              _buildSwitcherShown(),
              const SizedBox(height: 30),
              _buildSwitcherRecommended(),
              const SizedBox(height: 50),
              _buttonSave(),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  _buildPhotoViewer(BuildContext context) {
    return Consumer<AddProductProvider>(
      builder: (context, prov, child) {
        return SizedBox(
          width: 150,
          height: 150,
          child: InkWell(
            onTap: () {
              _showSheet(context);
            },
            child: prov.photo.image != null
                ? CircleAvatar(
                    backgroundImage: MemoryImage(prov.photo.image!),
                  )
                : const Material(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12.0),
                      ),
                    ),
                    child: Icon(
                      Icons.person,
                      color: Colors.black,
                      size: 50,
                    ),
                  ),
          ),
        );
      },
    );
  }

  Future<dynamic> _showSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return SizedBox(
          height: 150,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildPickPhotoFromCamera(),
              const SizedBox(width: 15),
              _buildPickPhotoFromGalery(),
              const SizedBox(width: 15),
              _buildDeletePhoto(),
            ],
          ),
        );
      },
    );
  }

  _buildPickPhotoFromGalery() {
    return Consumer<AddProductProvider>(
      builder: (context, prov, child) {
        return FloatingActionButton(
          onPressed: () async {
            prov.photo = await PasarAjaUtils.pickPhoto(
              ImageSource.gallery,
            ) as ChoosePhotoEntity;
            Get.back();
          },
          backgroundColor: Colors.purple,
          heroTag: 'galery',
          child: const Icon(
            Icons.image_outlined,
            color: Colors.white,
          ),
        );
      },
    );
  }

  _buildPickPhotoFromCamera() {
    return Consumer<AddProductProvider>(
      builder: (context, prov, child) {
        return FloatingActionButton(
          onPressed: () async {
            prov.photo = await PasarAjaUtils.pickPhoto(
              ImageSource.camera,
            ) as ChoosePhotoEntity;

            Get.back();
          },
          backgroundColor: Colors.black,
          heroTag: 'camera',
          child: const Icon(
            Icons.camera_alt_outlined,
            color: Colors.white,
          ),
        );
      },
    );
  }

  _buildDeletePhoto() {
    return Consumer<AddProductProvider>(
      builder: (context, prov, child) {
        return prov.photo.image != null
            ? FloatingActionButton(
                onPressed: () {
                  prov.photo = const ChoosePhotoEntity(
                    image: null,
                    imageSelected: null,
                  );
                  Get.back();
                },
                backgroundColor: Colors.blueGrey,
                heroTag: 'delete',
                child: const Icon(
                  Icons.delete_outlined,
                  color: Colors.white,
                ),
              )
            : const Material();
      },
    );
  }

  _buildInputNamaProduk() {
    return Consumer<AddProductProvider>(
      builder: (context, prov, child) {
        // get controller
        final nameCont = prov.nameCont;

        return AppInputText(
          title: "Nama Produk",
          textField: AppTextField(
            fontSize: 20,
            maxLength: 50,
            showCounter: true,
            hintText: 'Bawang Putih',
            controller: nameCont,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            errorText: prov.vNama.message,
            onChanged: (value) {
              prov.onValidateName(value);
            },
            suffixAction: () {
              nameCont.text = '';
              prov.vNama = PasarAjaValidation.productName('');
              prov.buttonState = ActionButton.stateDisabledButton;
            },
          ),
        );
      },
    );
  }

  _buildInputCategory() {
    final categoryCont = TextEditingController(text: widget.categoryName);
    return AppInputText(
      title: "Category",
      textField: AppTextField(
        readOnly: true,
        controller: categoryCont,
        fontSize: 19,
        hintText: '',
        suffixIcon: const Material(),
        keyboardType: TextInputType.number,
        formatters: MerchantTextField.numberFormatter(),
      ),
    );
  }

  _buildInputDeskripsi() {
    return Consumer<AddProductProvider>(
      builder: (context, prov, child) {
        // controller
        final descCont = prov.descCont;

        return AppInputText(
          title: "Deskripsi (opsional)",
          textField: AppTextField(
            controller: descCont,
            fontSize: 15,
            maxLength: 250,
            showCounter: true,
            hintText: 'Lorem ipsum dolor sit amet',
            onChanged: (value) {
              prov.refreshDesc();
            },
            suffixAction: () {
              descCont.text = '';
              prov.vDesc = PasarAjaValidation.descriptionProduct(null);
              prov.refreshDesc();
            },
          ),
        );
      },
    );
  }

  _inputUnitJual() {
    return Consumer<AddProductProvider>(
      builder: (context, prov, child) {
        return AppInputComboBox(
          title: "Unit Jual",
          comboBox: AppComboBox(
            selected: prov.selectedUnit,
            items: prov.units,
            onChanged: (value) {
              prov.selectedUnit = value ?? 'Pilih Unit';
            },
          ),
        );
      },
    );
  }

  _buildSatuanJual() {
    return Consumer<AddProductProvider>(
      builder: (context, prov, child) {
        // controller
        final sellingCont = prov.sellingCont;
        return AppInputText(
          title: "Satuan Jual",
          textField: AppTextField(
            controller: sellingCont,
            hintText: '1',
            fontSize: 20,
            maxLength: 11,
            showCounter: true,
            textInputAction: TextInputAction.next,
            errorText: prov.vSelling.message,
            keyboardType: TextInputType.number,
            formatters: MerchantTextField.numberFormatter(),
            onChanged: (value) {
              prov.onValidateSelling(value);
            },
            suffixAction: () {
              sellingCont.text = '';
              prov.vSelling = PasarAjaValidation.sellingUnit('');
              prov.buttonState = ActionButton.stateDisabledButton;
            },
          ),
        );
      },
    );
  }

  _buildInputHargaJual() {
    return Consumer<AddProductProvider>(
      builder: (context, prov, child) {
        // get controller
        final priceCont = prov.priceCont;

        return AppInputText(
          title: "Harga Jual",
          textField: AppTextField(
            controller: priceCont,
            errorText: prov.vPrice.message,
            maxLength: 11,
            showCounter: true,
            hintText: '1000',
            keyboardType: TextInputType.number,
            formatters: MerchantTextField.numberFormatter(),
            textInputAction: TextInputAction.done,
            onChanged: (value) {
              prov.onValidatePrice(value);
            },
            suffixAction: () {
              priceCont.text = '';
              prov.vPrice = PasarAjaValidation.price('');
              prov.buttonState = ActionButton.stateDisabledButton;
            },
          ),
        );
      },
    );
  }

  _buildSwitcherShown() {
    return Consumer<AddProductProvider>(
      builder: (context, prov, child) {
        return SwitcherSetting(
          title: "Tampilkan Produk",
          description: 'Tampilkan produk pada beranda pembeli.',
          value: prov.isShown,
          onChanged: (value) {
            prov.isShown = value;
          },
        );
      },
    );
  }

  _buildSwitcherRecommended() {
    return Consumer<AddProductProvider>(
      builder: (context, prov, child) {
        return SwitcherSetting(
          title: "Rekomendasikan Produk",
          description: 'Rekomendasikan produk pada halaman toko',
          value: prov.isRecommended,
          onChanged: (value) {
            prov.isRecommended = value;
          },
        );
      },
    );
  }

  _buttonSave() {
    return Consumer<AddProductProvider>(
      builder: (context, prov, child) {
        return ActionButton(
          onPressed: () {},
          title: 'Simpan',
          state: prov.buttonState,
        );
      },
    );
  }
}
