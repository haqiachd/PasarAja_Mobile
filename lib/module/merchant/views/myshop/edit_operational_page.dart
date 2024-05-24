import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/widgets/merchant_sub_appbar.dart';

class EditOperationalPage extends StatefulWidget {
  const EditOperationalPage({super.key});

  @override
  State<EditOperationalPage> createState() =>
      _EditOperationalPageState();
}

class _EditOperationalPageState extends State<EditOperationalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: merchantSubAppbar('Edit Jam Buka'),
      body: SingleChildScrollView(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
