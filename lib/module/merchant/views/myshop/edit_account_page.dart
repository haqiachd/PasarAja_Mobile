import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/widgets/action_button.dart';
import 'package:pasaraja_mobile/config/widgets/app_input_text.dart';
import 'package:pasaraja_mobile/config/widgets/app_textfield.dart';
import 'package:pasaraja_mobile/config/widgets/loading_indicator.dart';
import 'package:pasaraja_mobile/config/widgets/merchant_sub_appbar.dart';
import 'package:pasaraja_mobile/config/widgets/page_error_message.dart';
import 'package:pasaraja_mobile/config/widgets/something_wrong.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/core/utils/validations.dart';
import 'package:pasaraja_mobile/module/merchant/providers/myshop/edit_account_provider.dart';
import 'package:provider/provider.dart';

class EditAccountPage extends StatefulWidget {
  const EditAccountPage({
    Key? key,
    required this.email,
    required this.fullName,
    required this.phoneNumber,
  }) : super(key: key);

  final String email;
  final String fullName;
  final String phoneNumber;

  @override
  State<EditAccountPage> createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<EditAccountProvider>().setData(
            email: widget.email,
            fullName: widget.fullName,
            phoneNumber: widget.phoneNumber,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: merchantSubAppbar(
        'Edit Akun',
      ),
      body: Consumer<EditAccountProvider>(
        builder: (context, provider, child) {
          if (provider.state is OnLoadingState) {
            return const LoadingIndicator();
          }

          if (provider.state is OnFailureState) {
            return PageErrorMessage(
              onFailureState: provider.state as OnFailureState,
            );
          }

          if (provider.state is OnSuccessState) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    _buildInputEmail(),
                    const SizedBox(height: 15),
                    _buildInputPhone(),
                    const SizedBox(height: 15),
                    _buildInputNamaProduk(),
                    const SizedBox(height: 40),
                    _buttonSave(),
                  ],
                ),
              ),
            );
          }

          return const SomethingWrong();
        },
      ),
    );
  }

  _buildInputEmail() {
    return Consumer<EditAccountProvider>(
      builder: (context, prov, child) {
        // get controller
        final emailCont = prov.emailCont;

        return AppInputText(
          title: "Email Anda",
          textField: AppTextField(
            fontSize: 20,
            maxLength: 50,
            showCounter: true,
            hintText: 'pasaraja@email.com',
            controller: emailCont,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            readOnly: true,
            suffixIcon: const Icon(
              Icons.info_outline_rounded,
              color: PasarAjaColor.gray1,
            ),
            suffixAction: () {
              Fluttertoast.showToast(msg: "Email tidak bisa diedit");
            },
          ),
        );
      },
    );
  }

  _buildInputPhone() {
    return Consumer<EditAccountProvider>(
      builder: (context, prov, child) {
        // get controller
        final phoneCont = prov.phoneCont;

        return AppInputText(
          title: "Nomor HP",
          textField: AppTextField(
            fontSize: 20,
            maxLength: 50,
            showCounter: true,
            hintText: '0856',
            controller: phoneCont,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            readOnly: true,
            suffixIcon: const Icon(
              Icons.info_outline_rounded,
              color: PasarAjaColor.gray1,
            ),
            suffixAction: () {
              Fluttertoast.showToast(msg: "Email tidak bisa diedit");
            },
          ),
        );
      },
    );
  }

  _buildInputNamaProduk() {
    return Consumer<EditAccountProvider>(
      builder: (context, prov, child) {
        // get controller
        final nameCont = prov.nameCont;

        return AppInputText(
          title: "Nama Produk",
          textField: AppTextField(
            fontSize: 20,
            maxLength: 50,
            showCounter: true,
            hintText: 'PasarAja',
            controller: nameCont,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            errorText: prov.vName.message,
            onChanged: (value) {
              prov.onValidateName(value);
            },
            suffixAction: () {
              nameCont.text = '';
              prov.vName = PasarAjaValidation.productName('');
              prov.buttonState = ActionButton.stateDisabledButton;
            },
          ),
        );
      },
    );
  }

  _buttonSave() {
    return Consumer<EditAccountProvider>(
      builder: (context, prov, child) {
        return ActionButton(
          onPressed: () async{
            await prov.updateAccount();
          },
          title: 'Update Akun',
          state: prov.buttonState,
        );
      },
    );
  }
}
