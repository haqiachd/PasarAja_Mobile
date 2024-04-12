import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';
import 'package:pasaraja_mobile/config/widgets/app_radio.dart';
import 'package:pasaraja_mobile/config/widgets/merchant_sub_appbar.dart';
import 'package:pasaraja_mobile/module/merchant/providers/providers.dart';
import 'package:provider/provider.dart';

class OrderCancelPage extends StatefulWidget {
  const OrderCancelPage({
    super.key,
    required this.orderCode,
  });

  final String orderCode;

  @override
  State<OrderCancelPage> createState() => _OrderCancelPageState();
}

class _OrderCancelPageState extends State<OrderCancelPage> {
  @override
  void initState() {
    super.initState();
    context.read<OrderCancelProvider>().resetData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: merchantSubAppbar("Batalkan Pesanan"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Text(
                "Pilih Alasan Pembatalan",
                style: PasarAjaTypography.sfpdBold.copyWith(
                  fontSize: 18,
                ),
              ),
              _buildRadioTokoTutup(),
              _buildRadioInfoProd(),
              _buildRadioStokHabis(),
              _buildRadioOther(),
              const SizedBox(height: 20),
              Text(
                "Tulis Pesan Pembatalan",
                style: PasarAjaTypography.sfpdBold.copyWith(
                  fontSize: 18,
                ),
              ),
              _buildInputPesan(),
              const SizedBox(height: 20),
              _buildButtonReject(),
            ],
          ),
        ),
      ),
    );
  }

  _buildInputPesan() {
    return Consumer<OrderCancelProvider>(
      builder: (context, trx, child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: trx.pesanCont,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: "Tulis pesan pembatalan di sini...",
              border: OutlineInputBorder(),
            ),
          ),
        );
      },
    );
  }

  _buildButtonReject() {
    return Consumer<OrderCancelProvider>(
      builder: (context, trx, child) {
        return SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              trx.cancelOrder(
                orderCode: widget.orderCode,
              );
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
            child: const Text(
              'Batalkan Pesanan',
              style: TextStyle(
                color: Colors.red, // Ubah warna teks menjadi merah
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        );
      },
    );
  }

  _buildRadioStokHabis() {
    return Consumer<OrderCancelProvider>(
      builder: (context, prov, child) {
        return AppRadio(
          title: "Stok Sedang Habis",
          isSelected: prov.stokHabisRadio,
          onChange: (value) {
            DMethod.log('test');
            prov.stokHabisRadio = !prov.stokHabisRadio;
          },
        );
      },
    );
  }

  _buildRadioInfoProd() {
    return Consumer<OrderCancelProvider>(
      builder: (context, prov, child) {
        return AppRadio(
          title: "Kesalahan Informasi Produk",
          isSelected: prov.salahInfoRadio,
          onChange: (value) {
            DMethod.log('test');
            prov.salahInfoRadio = !prov.salahInfoRadio;
          },
        );
      },
    );
  }

  _buildRadioTokoTutup() {
    return Consumer<OrderCancelProvider>(
      builder: (context, prov, child) {
        return AppRadio(
          title: "Toko Tutup",
          isSelected: prov.tokoTutupRadio,
          onChange: (value) {
            DMethod.log('test');
            prov.tokoTutupRadio = !prov.tokoTutupRadio;
          },
        );
      },
    );
  }

  _buildRadioOther() {
    return Consumer<OrderCancelProvider>(
      builder: (context, prov, child) {
        return AppRadio(
          title: "lainnya",
          isSelected: prov.lainnyaRadio,
          onChange: (value) {
            DMethod.log('test');
            prov.lainnyaRadio = !prov.lainnyaRadio;
          },
        );
      },
    );
  }
}
