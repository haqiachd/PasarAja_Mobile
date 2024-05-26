import 'package:cached_network_image/cached_network_image.dart';
import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pasaraja_mobile/config/widgets/action_button.dart';
import 'package:pasaraja_mobile/config/widgets/app_input_text.dart';
import 'package:pasaraja_mobile/config/widgets/app_input_textarea.dart';
import 'package:pasaraja_mobile/config/widgets/app_textarea.dart';
import 'package:pasaraja_mobile/config/widgets/app_textfield.dart';
import 'package:pasaraja_mobile/config/widgets/image_network_error.dart';
import 'package:pasaraja_mobile/config/widgets/image_network_placeholder.dart';
import 'package:pasaraja_mobile/config/widgets/merchant_sub_appbar.dart';
import 'package:pasaraja_mobile/core/utils/validations.dart';
import 'package:pasaraja_mobile/module/auth/widgets/filled_button.dart';
import 'package:pasaraja_mobile/module/auth/widgets/textfield.dart';
import 'package:pasaraja_mobile/module/merchant/models/order/shop_data_model.dart';
import 'package:pasaraja_mobile/module/merchant/providers/myshop/edit_shop_provider.dart';
import 'package:provider/provider.dart';

class EditShopPage extends StatefulWidget {
  const EditShopPage({
    super.key,
    required this.shopData,
  });

  final ShopDataModel shopData;

  @override
  State<EditShopPage> createState() => _EditShopPageState();
}

class _EditShopPageState extends State<EditShopPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      try {
        context.read<EditShopProvider>().init(widget.shopData);
      } catch (ex) {
        Fluttertoast.showToast(msg: ex.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: merchantSubAppbar('Edit Data Toko'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildPhotoViewer(context),
              const SizedBox(height: 30),
              _buildNamaToko(),
              const SizedBox(height: 15),
              _buildNohp(),
              const SizedBox(height: 15),
              _buildBenchmark(),
              const SizedBox(height: 15),
              _buildDescription(),
              const SizedBox(height: 30),
              _buildButton(),
            ],
          ),
        ),
      ),
    );
  }

  _buildPhotoViewer(BuildContext context) {
    return Consumer<EditShopProvider>(
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
                _showSheet(context);
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
    return Consumer<EditShopProvider>(
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
    return Consumer<EditShopProvider>(
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

  _buildNamaToko() {
    return Consumer<EditShopProvider>(
      builder: (context, provider, child) {
        var nameCont = provider.nameCont;

        return AppInputText(
          title: 'Edit Nama Toko',
          textField: AppTextField(
            controller: nameCont,
            fontSize: 20,
            maxLength: 50,
            showCounter: true,
            hintText: 'Toko PasarAja',
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            errorText: provider.vName.message,
            onChanged: (value) {
              provider.onValidateName(value);
            },
            suffixAction: () {
              nameCont.text = '';
              provider.vName = PasarAjaValidation.shopName('');
              provider.buttonState = ActionButton.stateDisabledButton;
            },
          ),
        );
      },
    );
  }

  _buildNohp() {
    return Consumer<EditShopProvider>(
      builder: (context, provider, child) {
        var nohpCont = provider.noHpCont;
        return AppInputText(
          title: 'Edit Nomor HP',
          textField: AppTextField(
            controller: nohpCont,
            fontSize: 20,
            maxLength: 50,
            prefixText: '+62 ',
            showCounter: true,
            hintText: '85655878',
            keyboardType: TextInputType.number,
            formatters: AuthTextField.numberFormatter(),
            textInputAction: TextInputAction.next,
            errorText: provider.vNoHp.message,
            onChanged: (value) {
              provider.onValidatePhone(value);
            },
            suffixAction: () {
              nohpCont.text = '';
              provider.vNoHp = PasarAjaValidation.phone('');
              provider.buttonState = ActionButton.stateDisabledButton;
            },
          ),
        );
      },
    );
  }

  _buildBenchmark() {
    return Consumer<EditShopProvider>(
      builder: (context, provider, child) {
        var benchCont = provider.benchmarkCont;

        return AppInputText(
          title: 'Edit Titik Lokasi',
          textField: AppTextField(
            controller: benchCont,
            fontSize: 20,
            maxLength: 50,
            showCounter: true,
            hintText: 'Dekat Toko A',
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            errorText: provider.vBench.message,
            onChanged: (value) {
              provider.onValidateBench(value);
            },
            suffixAction: () {
              benchCont.text = '';
              provider.vBench = PasarAjaValidation.shopBenchmark('');
              provider.buttonState = ActionButton.stateDisabledButton;
            },
          ),
        );
      },
    );
  }

  _buildDescription() {
    return Consumer<EditShopProvider>(
      builder: (context, provider, child) {
        return AppInputTextArea(
          title: 'Edit Deskripsi',
          textArea: AppTextArea(
            controller: provider.descCont,
            fontSize: 17,
            maxLength: 500,
            showCounter: true,
            hintText: 'Lorem ipsum dolor sit amet',
            suffixAction: () {
              provider.descCont.text = '';
            },
          ),
        );
      },
    );
  }

  _buildButton() {
    return Consumer<EditShopProvider>(
      builder: (context, provider, child) {
        return AuthFilledButton(
          onPressed: () async{
            await provider.onButtonSavePressed();
          },
          title: 'Simpan',
          state: provider.buttonState,
        );
      },
    );
  }
}
