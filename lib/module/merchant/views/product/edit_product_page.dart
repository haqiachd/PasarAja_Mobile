import 'package:cached_network_image/cached_network_image.dart';
import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';
import 'package:pasaraja_mobile/config/widgets/action_button.dart';
import 'package:pasaraja_mobile/config/widgets/app_combobox.dart';
import 'package:pasaraja_mobile/config/widgets/app_input_combobox.dart';
import 'package:pasaraja_mobile/config/widgets/app_input_text.dart';
import 'package:pasaraja_mobile/config/widgets/app_input_textarea.dart';
import 'package:pasaraja_mobile/config/widgets/app_textarea.dart';
import 'package:pasaraja_mobile/config/widgets/app_textfield.dart';
import 'package:pasaraja_mobile/config/widgets/image_network_error.dart';
import 'package:pasaraja_mobile/config/widgets/image_network_placeholder.dart';
import 'package:pasaraja_mobile/core/utils/validations.dart';
import 'package:pasaraja_mobile/module/merchant/models/product/choose_categories_model.dart';
import 'package:pasaraja_mobile/module/merchant/models/product/product_detail_page_model.dart';
import 'package:pasaraja_mobile/module/merchant/providers/product/edit_product_provider.dart';
import 'package:pasaraja_mobile/module/merchant/widgets/switcher_setting.dart';
import 'package:provider/provider.dart';

class EditProductPage extends StatefulWidget {
  const EditProductPage({
    super.key,
    required this.prodDetail,
  });

  final ProductDetailModel prodDetail;

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      try {
        await Provider.of<EditProductProvider>(
          context,
          listen: false,
        ).setData(widget.prodDetail);
      } catch (ex) {
        Fluttertoast.showToast(msg: ex.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Edit Page'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Column(
            children: [
              const SizedBox(height: 15),
              _buildPhotoViewer(context),
              const SizedBox(height: 30),
              _buildInputNamaProduk(),
              const SizedBox(height: 15),
              _buildCategoryProd(context),
              const SizedBox(height: 15),
              _buildInputDeskripsi(),
              const SizedBox(height: 15),
              _buildInputUnitJual(),
              const SizedBox(height: 15),
              _buildSatuanJual(),
              const SizedBox(height: 15),
              _buildInputHargaJual(),
              const SizedBox(height: 30),
              _buildSwitcherRecommended(),
              const SizedBox(height: 30),
              _buildSwitcherShown(),
              const SizedBox(height: 30),
              _buildSwitcherStock(),
              const SizedBox(height: 50),
              _buttonSave(),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  _buildBottomSheetCategory(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Consumer<EditProductProvider>(
          builder: (context, prov, child) {
            final categories = prov.categories;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Text(
                    'Silahkan Pilih Kategori',
                    style: PasarAjaTypography.sfpdBold.copyWith(fontSize: 24),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      ChooseCategoriesModel category = categories[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: category.photo,
                            ),
                          ),
                          title: Text(
                            category.categoryName,
                            style: PasarAjaTypography.sfpdSemibold,
                          ),
                          onTap: () {
                            prov.selectedCategoryName = category.categoryName;
                            prov.selectedCategoryId = category.idCategory;
                            Get.back();
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  _buildPhotoViewer(BuildContext context) {
    return Consumer<EditProductProvider>(
      builder: (context, prov, child) {
        final photoCont = prov.photoCont;
        DMethod.log("Photo Cont : ${photoCont.text}");
        return Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: 130,
            height: 130,
            child: InkWell(
              onTap: () {
                Fluttertoast.showToast(msg: 'foto di tap');
              },
              child: photoCont.text.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: prov.photoCont.text,
                        placeholder: (context, str) {
                          return const ImageNetworkPlaceholder();
                        },
                        errorWidget: (context, str, obj) {
                          return const ImageErrorNetwork();
                        },
                        fit: BoxFit.cover,
                      ),
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
          ),
        );
      },
    );
  }

  _buildInputNamaProduk() {
    return Consumer<EditProductProvider>(
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

  _buildCategoryProd(BuildContext context) {
    return Consumer<EditProductProvider>(
      builder: (context, prov, child) {
        // get controller
        final categoryCont = prov.categoryCont;

        return AppInputText(
          title: "Kategori Produk",
          textField: AppTextField(
            controller: categoryCont,
            readOnly: true,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            suffixIcon: const Icon(
              Icons.edit,
              color: PasarAjaColor.gray1,
            ),
            suffixAction: () {
              _buildBottomSheetCategory(context);
            },
          ),
        );
      },
    );
  }

  _buildInputDeskripsi() {
    return Consumer<EditProductProvider>(
      builder: (context, prov, child) {
        // controller
        final descCont = prov.descCont;
        DMethod.log("DESC : ${descCont.text}");

        return AppInputTextArea(
          title: "Deskripsi (opsional)",
          textArea: AppTextArea(
            controller: descCont,
            fontSize: 17,
            maxLength: 250,
            showCounter: true,
            hintText: 'Lorem ipsum dolor sit amet',
            onChanged: (value) {
              prov.refreshDesc();
            },
            suffixAction: () {
              descCont.text = '';
              prov.vDesc = PasarAjaValidation.descriptionProduct(null);
              // prov.refreshDesc();
            },
          ),
        );
      },
    );
  }

  _buildInputUnitJual() {
    return Consumer<EditProductProvider>(
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
    return Consumer<EditProductProvider>(
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
            formatters: AppTextField.numberFormatter(),
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
    return Consumer<EditProductProvider>(
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
            formatters: AppTextField.numberFormatter(),
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
    return Consumer<EditProductProvider>(
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
    return Consumer<EditProductProvider>(
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

  _buildSwitcherStock() {
    return Consumer<EditProductProvider>(
      builder: (context, prov, child) {
        return SwitcherSetting(
          title: "Ketersediaan Stok",
          description: 'Update ketersediaan stok dari produk',
          value: prov.isAvailable,
          onChanged: (value) {
            prov.isAvailable = value;
          },
        );
      },
    );
  }

  _buttonSave() {
    return Consumer<EditProductProvider>(
      builder: (context, prov, child) {
        return ActionButton(
          onPressed: () {
           prov.updateProduct();
          },
          title: 'Update',
          state: prov.buttonState,
        );
      },
    );
  }
}
