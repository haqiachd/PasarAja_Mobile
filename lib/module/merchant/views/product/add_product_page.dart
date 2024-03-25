import 'dart:io';
import 'dart:typed_data';

import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pasaraja_mobile/config/widgets/merchant_sub_appbar.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/utils/messages.dart';
import 'package:pasaraja_mobile/module/auth/widgets/widgets.dart';
import 'package:pasaraja_mobile/module/merchant/controllers/product_controller.dart';
import 'package:pasaraja_mobile/module/merchant/widgets/textfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _DetailProductPageState();
}

class _DetailProductPageState extends State<AddProductPage> {
  TextEditingController nameCont = TextEditingController();
  TextEditingController descCont = TextEditingController();
  TextEditingController categoryCont = TextEditingController();
  TextEditingController unitCont = TextEditingController();
  TextEditingController sellingCont = TextEditingController();
  TextEditingController priceCont = TextEditingController();
  // file
  Uint8List? _image;
  File? imageSelected;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: merchantSubAppbar("Tambah Produk"),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 15),
              SizedBox(
                width: 150,
                height: 150,
                child: InkWell(
                  onTap: () {
                    _showSheet(context);
                  },
                  child: _image != null
                      ? CircleAvatar(
                          backgroundImage: MemoryImage(_image!),
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
              const SizedBox(height: 15),
              AuthInputText(
                title: "Nama Produk",
                textField: AuthTextField(
                  controller: nameCont,
                  hintText: '',
                ),
              ),
              const SizedBox(height: 10),
              AuthInputText(
                title: "Category",
                textField: AuthTextField(
                  controller: categoryCont,
                  hintText: '',
                  keyboardType: TextInputType.number,
                  formatters: MerchantTextField.numberFormatter(),
                ),
              ),
              const SizedBox(height: 10),
              AuthInputText(
                title: "Deskripsi",
                textField: AuthTextField(
                  controller: descCont,
                  hintText: '',
                ),
              ),
              const SizedBox(height: 10),
              AuthInputText(
                title: "Unit Jual",
                textField: AuthTextField(
                  controller: unitCont,
                  hintText: '',
                ),
              ),
              const SizedBox(height: 10),
              AuthInputText(
                title: "Satuan Jual",
                textField: AuthTextField(
                  controller: sellingCont,
                  hintText: '',
                  keyboardType: TextInputType.number,
                  formatters: MerchantTextField.numberFormatter(),
                ),
              ),
              const SizedBox(height: 10),
              AuthInputText(
                title: "Harga Jual",
                textField: AuthTextField(
                  controller: priceCont,
                  hintText: '',
                  keyboardType: TextInputType.number,
                  formatters: MerchantTextField.numberFormatter(),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  DMethod.log("Nama : ${nameCont.text}");
                  DMethod.log("Category : ${categoryCont.text}");
                  DMethod.log("Deskripsi : ${descCont.text}");
                  DMethod.log("Unit : ${descCont.text}");
                  DMethod.log("Satuan Jual : ${sellingCont.text}");
                  DMethod.log("Harag : ${priceCont.text}");
                  DMethod.log("File : ${imageSelected?.path ?? 'NULL'}");
                  // DMethod.log("Other : ${_image}");
                  // upload
                  PasarAjaMessage.showLoading();
                  final controller = ProductController();
                  final dataState = await controller.addProduct(
                    idShop: 1,
                    idCategory: int.parse(categoryCont.text),
                    productName: nameCont.text,
                    description: descCont.text,
                    unit: unitCont.text,
                    sellingUnit: int.parse(sellingCont.text),
                    photo: imageSelected!,
                    price: int.parse(priceCont.text),
                  );

                  //
                  Get.back();
                  if (dataState is DataSuccess) {
                    await PasarAjaMessage.showInformation(
                      "produk berhasil ditambahkan",
                    );
                    Get.back();
                  }

                  if (dataState is DataFailed) {
                    Fluttertoast.showToast(msg: "ERROR : ${dataState.error!}");
                    DMethod.log("ERROR : ${dataState.error}");
                  }
                },
                child: const Text("Simpan"),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
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
              FloatingActionButton(
                onPressed: () => _pickPhoto(ImageSource.camera),
                backgroundColor: Colors.black,
                heroTag: 'camera',
                child: const Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 15),
              FloatingActionButton(
                onPressed: () => _pickPhoto(ImageSource.gallery),
                backgroundColor: Colors.purple,
                heroTag: 'galery',
                child: const Icon(
                  Icons.image_outlined,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 15),
              _image != null
                  ? FloatingActionButton(
                      onPressed: () {
                        setState(() => _image = null);
                        Navigator.pop(context);
                      },
                      backgroundColor: Colors.blueGrey,
                      heroTag: 'delete',
                      child: const Icon(
                        Icons.delete_outlined,
                        color: Colors.white,
                      ),
                    )
                  : const Material(),
            ],
          ),
        );
      },
    );
  }

  Future _pickPhoto(ImageSource imageSource) async {
    final returnImage = await ImagePicker().pickImage(source: imageSource);
    DMethod.log('from photo');
    if (returnImage != null) {
      setState(() {
        imageSelected = File(returnImage.path);
        _image = File(returnImage.path).readAsBytesSync();
      });
    } else {
      return null;
    }

    Get.back();
  }
}
