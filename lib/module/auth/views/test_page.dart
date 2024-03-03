import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/module/auth/widgets/widgets.dart';

class MyTestPage extends StatefulWidget {
  const MyTestPage({super.key});

  @override
  State<MyTestPage> createState() => _MyTestPageState();
}

class _MyTestPageState extends State<MyTestPage> {
  bool isLoading = true;
  int state = CustomElevatedButton.stateDisabledButton;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PasarAjaColor.white,
      appBar: authAppbar(),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 100),
            AuthFilledButton(
              title: "Daftar",
              state: state,
              onPressed: () async {
                setState(() => state = CustomElevatedButton.stateLoadingButton);
                await Future.delayed(const Duration(seconds: 3));
                setState(() => state = CustomElevatedButton.stateEnabledButton);
              },
            ),
            const SizedBox(height: 100),
            testButton(),
            const SizedBox(height: 100),
            loginSatu('Masuk'),
            const SizedBox(height: 100),
            ElevatedButton(
              onPressed: () {
                if (state == AuthFilledButton.stateDisabledButton) {
                  state = AuthFilledButton.stateEnabledButton;
                } else {
                  state = AuthFilledButton.stateDisabledButton;
                }

                setState(() {});
              },
              child: const Text('Submit'),
            )
          ],
        ),
      ),
    );
  }

  CustomElevatedButton testButton() {
    return CustomElevatedButton(
      title: 'Login',
      state: state,
      onPressed: () async {
        // setState(() => isLoading = true);
        setState(() => state = CustomElevatedButton.stateLoadingButton);
        await Future.delayed(const Duration(seconds: 3));
        // setState(() => isLoading = false);
        setState(() => state = CustomElevatedButton.stateEnabledButton);
      },
    );
  }

  ElevatedButton loginSatu(String title) {
    return ElevatedButton(
      onPressed: () async {
        isLoading = true;
        setState(() => isLoading = true);
        await Future.delayed(const Duration(seconds: 1));
        setState(() => isLoading = false);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: PasarAjaColor.green2,
        foregroundColor: PasarAjaColor.white,
      ),
      child: isLoading
          ? const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 25,
                  height: 25,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                ),
              ],
            )
          : Text(title),
    );
  }
}
