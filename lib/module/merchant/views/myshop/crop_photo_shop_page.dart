import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pasaraja_mobile/config/widgets/action_button.dart';
import 'package:pasaraja_mobile/config/widgets/merchant_sub_appbar.dart';
import 'package:pasaraja_mobile/module/merchant/providers/myshop/crop_photo_shop_provider.dart';
import 'package:provider/provider.dart';

class CropPhotoShopPage extends StatefulWidget {
  const CropPhotoShopPage({
    Key? key,
    required this.idShop,
    required this.imageFile,
  }) : super(key: key);

  final int idShop;
  final File imageFile;

  @override
  State<CropPhotoShopPage> createState() => _CropPhotoShopPageState();
}

class _CropPhotoShopPageState extends State<CropPhotoShopPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<CropPhotoShopProvider>().idShop = widget.idShop;
      context.read<CropPhotoShopProvider>().imageFile = widget.imageFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: merchantSubAppbar('Pilih Foto Toko'),
      body: Column(
        children: [
          const SizedBox(height: 30),
          _buildPhotoViewer(context),
          const SizedBox(height: 30),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildButtonUpload(),
                  const SizedBox(height: 15),
                  _buildButtonGanti(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildButtonGanti() {
    return Consumer<CropPhotoShopProvider>(
      builder: (context, provider, child) {
        return ActionButton(
          onPressed: () async {
            await _showSheet(context);
          },
          title: 'Ganti Foto Toko',
          state: ActionButton.stateEnabledButton,
        );
      },
    );
  }

  _buildButtonUpload() {
    return Consumer<CropPhotoShopProvider>(
      builder: (context, provider, child) {
        return ActionButton(
          onPressed: () async {
            await provider.uploadProduct();
          },
          title: "Update Photo",
          state: ActionButton.stateEnabledButton,
        );
      },
    );
  }

  _buildPhotoViewer(BuildContext context) {
    return Consumer<CropPhotoShopProvider>(
      builder: (context, prov, child) {
        return Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width / 1.1,
            height: MediaQuery.of(context).size.width / 1.1,
            child: Material(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(
                  color: Colors.grey,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.file(
                  prov.imageFile,
                  fit: BoxFit.cover,
                ),
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
            ],
          ),
        );
      },
    );
  }

  _buildPickPhotoFromGalery() {
    return Consumer<CropPhotoShopProvider>(
      builder: (context, prov, child) {
        return FloatingActionButton(
          onPressed: () async {
            Get.back();
            await prov.photoPicker(ImageSource.gallery);
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
    return Consumer<CropPhotoShopProvider>(
      builder: (context, prov, child) {
        return FloatingActionButton(
          onPressed: () async {
            Get.back();
            await prov.photoPicker(ImageSource.camera);
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
}
