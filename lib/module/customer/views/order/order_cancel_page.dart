import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/Typography.dart';
import 'package:pasaraja_mobile/config/widgets/app_radio.dart';
import 'package:pasaraja_mobile/module/customer/provider/providers.dart';
import 'package:pasaraja_mobile/module/customer/widgets/customer_sub_appbar.dart';
import 'package:provider/provider.dart';

class OrderCancelPage extends StatefulWidget {
  const OrderCancelPage({
    Key? key,
    required this.idShop,
    required this.orderCode,
  }) : super(
          key: key,
        );

  final int idShop;
  final String orderCode;

  @override
  State<OrderCancelPage> createState() => _OrderCancelPageState();
}

class _OrderCancelPageState extends State<OrderCancelPage> {
  @override
  void initState() {
    super.initState();
    context.read<CustomerOrderCancelProvider>().resetData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customerSubAppbar("Batalkan Pesanan"),
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
    return Consumer<CustomerOrderCancelProvider>(
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
    return Consumer<CustomerOrderCancelProvider>(
      builder: (context, trx, child) {
        return SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              trx.cancelOrder(
                idShop: widget.idShop,
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
    return Consumer<CustomerOrderCancelProvider>(
      builder: (context, prov, child) {
        return AppRadio(
          title: "Penjual Tidak Merespon",
          isSelected: prov.responsPenjual,
          onChange: (value) {
            DMethod.log('test');
            prov.responsPenjual = !prov.responsPenjual;
          },
        );
      },
    );
  }

  _buildRadioInfoProd() {
    return Consumer<CustomerOrderCancelProvider>(
      builder: (context, prov, child) {
        return AppRadio(
          title: "Ingin Ganti Produk",
          isSelected: prov.gantiProduk,
          onChange: (value) {
            DMethod.log('test');
            prov.gantiProduk = !prov.gantiProduk;
          },
        );
      },
    );
  }

  _buildRadioTokoTutup() {
    return Consumer<CustomerOrderCancelProvider>(
      builder: (context, prov, child) {
        return AppRadio(
          title: "Berubah Pikiran",
          isSelected: prov.berubahPikiran,
          onChange: (value) {
            DMethod.log('test');
            prov.berubahPikiran = !prov.berubahPikiran;
          },
        );
      },
    );
  }

  _buildRadioOther() {
    return Consumer<CustomerOrderCancelProvider>(
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
