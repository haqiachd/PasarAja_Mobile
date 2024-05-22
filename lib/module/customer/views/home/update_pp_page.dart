import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pasaraja_mobile/config/widgets/action_button.dart';
import 'package:pasaraja_mobile/module/customer/provider/home/update_pp_provider.dart';
import 'package:pasaraja_mobile/module/customer/widgets/customer_sub_appbar.dart';
import 'package:provider/provider.dart';

class UpdatePhotoProfilePage extends StatefulWidget {
  const UpdatePhotoProfilePage({
    Key? key,
    required this.email,
    required this.imageFile,
  }) : super(key: key);

  final String email;
  final File imageFile;

  static int fromAddProduct = 1;
  static int fromEditProduct = 2;

  @override
  State<UpdatePhotoProfilePage> createState() => _UpdatePhotoProfilePageState();
}

class _UpdatePhotoProfilePageState extends State<UpdatePhotoProfilePage> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<UpdatePhotoProfileCustomerProvider>().email = widget.email;
      context.read<UpdatePhotoProfileCustomerProvider>().imageFile = widget.imageFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: customerSubAppbar('Pilih Foto Profile'),
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

  _buildPhotoViewer(BuildContext context) {
    return Consumer<UpdatePhotoProfileCustomerProvider>(
      builder: (context, prov, child) {
        return Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width / 1.1,
            height: MediaQuery.of(context).size.width / 1.1,
            child: Material(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width / 1.1),
                side: const BorderSide(
                  color: Colors.grey,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width / 1.1),
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

  _buildButtonGanti() {
    return Consumer<UpdatePhotoProfileCustomerProvider>(
      builder: (context, provider, child) {
        return ActionButton(
          onPressed: () async {
            await _showSheet(context);
          },
          title: 'Ganti Foto',
          state: ActionButton.stateEnabledButton,
        );
      },
    );
  }

  _buildButtonUpload() {
    return Consumer<UpdatePhotoProfileCustomerProvider>(
      builder: (context, provider, child) {
        return ActionButton(
          onPressed: () async {
            provider.updatePhoto();
          },
          title: "Simpan Foto Profil",
          state: ActionButton.stateEnabledButton,
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
    return Consumer<UpdatePhotoProfileCustomerProvider>(
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
    return Consumer<UpdatePhotoProfileCustomerProvider>(
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
