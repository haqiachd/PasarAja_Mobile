import 'package:pasaraja_mobile/config/themes/images.dart';

class PasarAjaLocalData {
  static List<WelcomeModel> wecomeList = const [
    WelcomeModel(
      image: PasarAjaImage.ilWelcome1,
      title: 'Selamat Datang di PasarAja!',
      description:
          'Nikmati kemudahan berbelanja di pasar melalui aplikasi PasarAja, yang selalu siap membantu memenuhi semua kebutuhanmu.',
    ),
    WelcomeModel(
      image: PasarAjaImage.ilWelcome2,
      title: 'Pesan Kebutuhanmu',
      description:
          'Temukan dan Pesan Kebutuhanmu di Pasar dengan Mudah dan Cepat Melalui aplikasi  PasarAja.',
    ),
    WelcomeModel(
      image: PasarAjaImage.ilWelcome3,
      title: 'Tidak Takut Kehabisan Stok',
      description:
          'Tidak Perlu Khawatir Stok Habis, Pesan Kebutuhanmu di Aplikasi Kami Terlebih Dahulu!',
    )
  ];
}

class WelcomeModel {
  final String? image;
  final String? title;
  final String? description;

  const WelcomeModel({this.image, this.title, this.description});
}
