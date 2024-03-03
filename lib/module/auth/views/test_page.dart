import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/core/data/data_state.dart';
import 'package:pasaraja_mobile/module/auth/controllers/test_controller.dart';
import 'package:pasaraja_mobile/module/auth/widgets/widgets.dart';

class MyTestPage extends StatefulWidget {
  const MyTestPage({super.key});

  @override
  State<MyTestPage> createState() => _MyTestPageState();
}

class _MyTestPageState extends State<MyTestPage> {
  bool isLoading = true;
  int state = CustomElevatedButton.stateEnabledButton;
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PasarAjaColor.white,
      appBar: authAppbar(),
      body: Center(
        child: Column(
          children: [
            AuthInputText(
              title: 'Input Email',
              textField: AuthTextField(
                controller: controller,
                autofillHints: [AutofillHints.email],
              ),
            ),
            AuthFilledButton(
              onPressed: () async {
                TestController testController = TestController();
                // request login
                final DataState response = await testController.loginDio(
                  email: controller.text,
                );

                if (response is DataSuccess) {
                  Fluttertoast.showToast(msg: 'Login berhasil');
                }

                if (response is DataFailed) {
                  Fluttertoast.showToast(msg: response.error!.message);
                }
              },
              title: 'Button',
              state: state,
            )
          ],
        ),
      ),
    );
  }
}
