import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/config/themes/Typography.dart';
import 'package:pasaraja_mobile/config/widgets/action_button.dart';
import 'package:pasaraja_mobile/config/widgets/loading_indicator.dart';
import 'package:pasaraja_mobile/config/widgets/merchant_sub_appbar.dart';
import 'package:pasaraja_mobile/config/widgets/page_error_message.dart';
import 'package:pasaraja_mobile/config/widgets/something_wrong.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/module/merchant/providers/myshop/edit_operational_provider.dart';
import 'package:provider/provider.dart';

class EditOperationalPage extends StatefulWidget {
  const EditOperationalPage({super.key});

  @override
  State<EditOperationalPage> createState() => _EditOperationalPageState();
}

class _EditOperationalPageState extends State<EditOperationalPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<EditOperationalProvider>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: merchantSubAppbar('Edit Hari Buka'),
      body: Consumer<EditOperationalProvider>(
        builder: (context, provider, child) {
          if (provider.state is OnLoadingState) {
            return const LoadingIndicator();
          }

          if (provider.state is OnFailureState) {
            return PageErrorMessage(
                onFailureState: provider.state as OnFailureState);
          }

          if (provider.state is OnSuccessState) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Nama Hari',
                          style: PasarAjaTypography.sfpdBold
                              .copyWith(fontSize: 20),
                        ),
                        Text(
                          'Status Buka',
                          style: PasarAjaTypography.sfpdBold
                              .copyWith(fontSize: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Divider(),
                    _buildMonday(),
                    _buildTuesday(),
                    _buildWednesday(),
                    _buildThursday(),
                    _buildFriday(),
                    _buildSaturday(),
                    _buildSunday(),
                    const SizedBox(height: 50),
                    _buildSaveButton(),
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

  _buildSaveButton() {
    return Consumer<EditOperationalProvider>(
      builder: (context, provider, child) {
        return ActionButton(
          onPressed: () {
            provider.onSaveButton();
          },
          title: 'Simpan',
          state: ActionButton.stateEnabledButton,
        );
      },
    );
  }

  _buildMonday() {
    return Consumer<EditOperationalProvider>(
      builder: (context, provider, child) {
        return JadwalWidget(
          day: 'Senin',
          isChecked: provider.monday,
          onChanged: () {
            DMethod.log('tessss');
            provider.monday = !provider.monday;
          },
        );
      },
    );
  }

  _buildTuesday() {
    return Consumer<EditOperationalProvider>(
      builder: (context, provider, child) {
        return JadwalWidget(
          day: 'Selasa',
          isChecked: provider.tuesday,
          onChanged: () {
            provider.tuesday = !provider.tuesday;
          },
        );
      },
    );
  }

  _buildWednesday() {
    return Consumer<EditOperationalProvider>(
      builder: (context, provider, child) {
        return JadwalWidget(
          day: 'Rabu',
          isChecked: provider.wednesday,
          onChanged: () {
            provider.wednesday = !provider.wednesday;
          },
        );
      },
    );
  }

  _buildThursday() {
    return Consumer<EditOperationalProvider>(
      builder: (context, provider, child) {
        return JadwalWidget(
          day: 'Kamis',
          isChecked: provider.thursday,
          onChanged: () {
            provider.thursday = !provider.thursday;
          },
        );
      },
    );
  }

  _buildFriday() {
    return Consumer<EditOperationalProvider>(
      builder: (context, provider, child) {
        return JadwalWidget(
          day: 'Jumat',
          isChecked: provider.friday,
          onChanged: () {
            provider.friday = !provider.friday;
          },
        );
      },
    );
  }

  _buildSaturday() {
    return Consumer<EditOperationalProvider>(
      builder: (context, provider, child) {
        return JadwalWidget(
          day: 'Sabtu',
          isChecked: provider.saturday,
          onChanged: () {
            provider.saturday = !provider.saturday;
          },
        );
      },
    );
  }

  _buildSunday() {
    return Consumer<EditOperationalProvider>(
      builder: (context, provider, child) {
        return JadwalWidget(
          day: 'Minggu',
          isChecked: provider.sunday,
          onChanged: () {
            provider.sunday = !provider.sunday;
          },
        );
      },
    );
  }
}

class JadwalWidget extends StatelessWidget {
  const JadwalWidget({
    super.key,
    required this.day,
    required this.isChecked,
    required this.onChanged,
  });

  final String day;
  final bool isChecked;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              day,
              style: PasarAjaTypography.sfpdBold.copyWith(fontSize: 20),
            ),
            Switch(
              value: isChecked,
              onChanged: (b) {
                onChanged();
              },
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }
}
