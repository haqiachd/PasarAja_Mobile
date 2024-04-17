import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pasaraja_mobile/config/widgets/merchant_sub_appbar.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';

class ChoosePhotoPage extends StatefulWidget {
  const ChoosePhotoPage({
    Key? key,
    required this.idProduct,
  }) : super(key: key);

  final int idProduct;

  @override
  State<ChoosePhotoPage> createState() => _ChoosePhotoPageState();
}

class _ChoosePhotoPageState extends State<ChoosePhotoPage> {

  File? imageFile;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: merchantSubAppbar('Pilih Foto Produk'),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            imageFile == null
                ? const Text('no photo')
                : ClipRRect(
                    child: Image.file(
                      imageFile!,
                      height: 300,
                      width: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async{
              final photo = await PasarAjaUtils.pickPhoto(ImageSource.camera);
              imageFile = await PasarAjaUtils.cropImage(photo!.imageSelected!);
              setState(() {
              });
            },
            backgroundColor: Colors.blueAccent,
            child: const Icon(
              Icons.photo_camera,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            onPressed: () async {
              final photo = await PasarAjaUtils.pickPhoto(ImageSource.gallery);
              imageFile = await PasarAjaUtils.cropImage(photo!.imageSelected!);
              setState(() {
              });
            },
            backgroundColor: Colors.deepPurpleAccent,
            child: const Icon(
              Icons.photo,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }

}
