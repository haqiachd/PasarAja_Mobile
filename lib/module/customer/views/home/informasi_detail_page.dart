import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/config/themes/Typography.dart';
import 'package:pasaraja_mobile/config/widgets/merchant_sub_appbar.dart';
import 'package:pasaraja_mobile/module/customer/models/event_model.dart';
import 'package:pasaraja_mobile/module/customer/models/informasi_model.dart';

class InformasiDetailPage extends StatefulWidget {
  const InformasiDetailPage({
    super.key,
    required this.informasi,
  });

  final InformasiModel informasi;

  @override
  State<InformasiDetailPage> createState() => _InformasiDetailPageState();
}

class _InformasiDetailPageState extends State<InformasiDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: merchantSubAppbar('Detail Informasi'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: Get.width,
              height: 200,
              child: CachedNetworkImage(
                imageUrl: widget.informasi.foto ?? '',
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    widget.informasi.judul ?? '',
                    style: PasarAjaTypography.sfpdBold.copyWith(fontSize: 24),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.informasi.deskripsi ?? '',
                    style: PasarAjaTypography.regular14.copyWith(fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
