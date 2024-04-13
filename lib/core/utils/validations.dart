import 'package:equatable/equatable.dart';

class PasarAjaValidation {
  static final RegExp regexNum = RegExp(r'[0-9]');
  static final RegExp regexNonDigit = RegExp(r'[^0-9]');
  static final RegExp regexSymbol = RegExp(r'[^\w\s]');
  static final RegExp regexSymbolName = RegExp(r"[^\w\s\.\-\'`,]");
  static final RegExp emailRegex = RegExp(
      r'^[_A-Za-z0-9-+]+(\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+(\.[A-Za-z0-9]+)*(\.[A-Za-z]{2,})$');
  static final RegExp regexLowerCase = RegExp(r'[a-z]');
  static final RegExp regexUpperCase = RegExp(r'[A-Z]');

  static bool containsNumber(String text) => regexNum.hasMatch(text);

  static bool containsNonDigit(String text) => regexNonDigit.hasMatch(text);

  static bool containsSymbol(String text) => regexSymbol.hasMatch(text);

  /// simbol yang dikecualikan . , - ' `
  static bool containsSymbolWithExceptions(String text) =>
      regexSymbolName.hasMatch(text);

  // static bool cotainsSymbolEmail(String text) =>
  //     regexSymbolEmail.hasMatch(text);

  static bool containsLowerCase(String text) => regexLowerCase.hasMatch(text);

  static bool containsUpperCase(String text) => regexUpperCase.hasMatch(text);

  static ValidationModel phone(String? phone) {
    if (phone == null) {
      return const ValidationModel(message: 'Phone null');
    }
    // Phone tidak boleh kosong
    if (phone.isEmpty) {
      return const ValidationModel(
        message: 'Nomor hp tidak boleh kosong',
      );
    }

    // Phone harus anggka
    if (containsNonDigit(phone)) {
      return const ValidationModel(
        message: 'Nomor hp tidak boleh mengandung karakter atau simbol',
      );
    }

    // Phone harus diatara 9-15 karakter 😃
    if (phone.length <= 9 || phone.length > 15) {
      return const ValidationModel(
        message: 'Panjang nomor hp harus di antara 9-15 karakter',
      );
    }

    // Phone valid
    return const ValidationModel(
      status: true,
      message: 'Data valid',
    );
  }

  static ValidationModel name(String? name) {
    if (name == null) {
      return const ValidationModel(message: 'Name null');
    }
    // Nama tidak boleh kosong
    if (name.isEmpty || name.trim().isEmpty) {
      return const ValidationModel(
        message: 'Nama tidak boleh kosong',
      );
    }

    // Panjang dari nama harus diatara 4-50 karakter
    if (name.length < 4 || name.length > 50) {
      return const ValidationModel(
        message: 'Panjang dari nama harus di antara 4-50 karakter',
      );
    }

    // Cek apakah nama mengandung simbol tertentu
    if (containsSymbolWithExceptions(name)) {
      return const ValidationModel(
        message: "Simbol yang diperbolehkan hanya . , ' ` dan -",
      );
    }

    // Nama valid
    return const ValidationModel(
      status: true,
      message: 'Data valid',
    );
  }

  static ValidationModel productName(String? name) {
    if (name == null) {
      return const ValidationModel(message: 'Name null');
    }
    // Nama tidak boleh kosong
    if (name.isEmpty || name.trim().isEmpty) {
      return const ValidationModel(
        message: 'Nama produk tidak boleh kosong',
      );
    }

    // Panjang dari nama harus diatara 4-50 karakter
    if (name.length < 4 || name.length > 50) {
      return const ValidationModel(
        message: 'Panjang dari nama harus di antara 4-50 karakter',
      );
    }

    // Nama valid
    return const ValidationModel(
      status: true,
      message: 'Data valid',
    );
  }

  static ValidationModel descriptionProduct(String? description) {
    if (description == null) {
      return const ValidationModel(message: 'Desc null');
    }

    // Panjang dari deskripsi harus kurang dari 250
    if (description.isNotEmpty && description.length > 250) {
      return const ValidationModel(
        message: 'Panjang dari deskripsi harus di antara 250 karakter',
      );
    }

    // Nama valid
    return const ValidationModel(
      status: true,
      message: 'Data valid',
    );
  }

  static ValidationModel sellingUnit(String? selling) {
    if (selling == null) {
      return const ValidationModel(message: 'Satuan jual null');
    }

    // Nama tidak boleh kosong
    if (selling.isEmpty || selling.trim().isEmpty) {
      return const ValidationModel(
        message: 'Satuan jual tidak boleh kosong',
      );
    }

    if (int.parse(selling) <= 0) {
      return const ValidationModel(
        message: 'Satuan jual minimal 1',
      );
    }

    // Nama valid
    return const ValidationModel(
      status: true,
      message: 'Data valid',
    );
  }

  static ValidationModel pin(String? pin) {
    if (pin == null) {
      return const ValidationModel(
        message: 'PIN null',
      );
    }
    // PIN tidak boleh kosong
    if (pin.isEmpty || pin.trim().isEmpty) {
      return const ValidationModel(
        message: 'PIN tidak boleh kosong.',
      );
    }

    // PIN harus 6 karakter
    if (pin.length != 6) {
      return const ValidationModel(
        message: 'PIN harus berjumlah 6 angka.',
      );
    }

    // PIN harus berupa angka
    if (containsNonDigit(pin)) {
      return const ValidationModel(
        message: 'PIN harus berupa angka.',
      );
    }

    // PIN valid
    return const ValidationModel(
      status: true,
      message: 'Data valid',
    );
  }

  static ValidationModel email(String? email) {
    if (email == null) {
      return const ValidationModel(message: 'Email null.');
    }
    // Periksa apakah email null atau tidak
    if (email.isEmpty || email.trim().isEmpty) {
      return const ValidationModel(message: 'Email tidak boleh kosong.');
    }

    // Panjang username harus kurang dari 100
    if (email.length > 100) {
      return const ValidationModel(
          message: "Panjang email tidak boleh lebih dari 100 karakter");
    }

    // cek validasi karakter
    if (emailRegex.hasMatch(email)) {
      return const ValidationModel(status: true, message: "Data valid");
    } else {
      return const ValidationModel(message: "Email tidak valid");
    }
  }

  static ValidationModel password(String? password) {
    if (password == null) {
      return const ValidationModel(message: 'Password null.');
    }
    // Password tidak boleh kosong
    if (password.isEmpty || password.trim().isEmpty) {
      return const ValidationModel(
        message: 'Password tidak boleh kosong.',
      );
    }

    // Password harus diantara 8-30 karakter
    if (password.length < 8 || password.length > 30) {
      return const ValidationModel(
        message: 'Password harus di antara 8-30 karakter.',
      );
    }

    // Password harus menggandung huruf besar
    if (!containsUpperCase(password)) {
      return const ValidationModel(
        message: 'Password harus mengandung huruf besar.',
      );
    }

    // Password harus menggandung huruf kecil
    if (!containsLowerCase(password)) {
      return const ValidationModel(
        message: 'Password harus mengandung huruf kecil.',
      );
    }

    // Password harus menggadung angka
    if (!containsNumber(password)) {
      return const ValidationModel(
        message: 'Password harus mengandung angka.',
      );
    }

    // Password harus meggandung simbol
    if (!containsSymbol(password)) {
      return const ValidationModel(
        message: 'Password harus mengandung simbol.',
      );
    }

    // Password valid
    return const ValidationModel(
      status: true,
      message: 'Data valid',
    );
  }

  static ValidationModel price(String? price) {
    if (price == null) {
      return const ValidationModel(message: 'Price null.');
    }
    if (price.isEmpty && price.trim().isEmpty) {
      return const ValidationModel(
        message: 'Harga tidak boleh kosong.',
      );
    }

    if (containsNonDigit(price)) {
      return const ValidationModel(
        message: 'Harga harus berupa angga',
      );
    }

    try {
      int harga = int.parse(price);
      if (harga <= 0) {
        return const ValidationModel(
          message: 'Harga minimial Rp. 1',
        );
      }

      if (harga > 9999999) {
        return const ValidationModel(
          message: 'Harga maksimal Rp. 9.999.999',
        );
      }
    } catch (ex) {
      return const ValidationModel(
        message: 'Harga tidak valid',
      );
    }

    return const ValidationModel(
      status: true,
      message: 'Data valid',
    );
  }

  static ValidationModel promoPrice(String? price, String? promoPrice) {
    if (price == null) {
      return const ValidationModel(message: 'Price null.');
    }
    if (price.isEmpty && price.trim().isEmpty) {
      return const ValidationModel(
        message: 'Harga tidak boleh kosong.',
      );
    }

    if (promoPrice == null) {
      return const ValidationModel(message: 'Promo price null.');
    }
    if (promoPrice.isEmpty && promoPrice.trim().isEmpty) {
      return const ValidationModel(
        message: 'Harga promo tidak boleh kosong.',
      );
    }

    // cek apakah harga valid atau tidak
    ValidationModel isPriceNumber = PasarAjaValidation.price(price);
    if (isPriceNumber.status == false) {
      return isPriceNumber;
    }

    // cek apakah promo valid atau tidak
    ValidationModel isPromoNumber = PasarAjaValidation.price(promoPrice);
    if (isPromoNumber.status == false) {
      return isPromoNumber;
    }

    final int priceInt = int.parse(price);
    final int promoInt = int.parse(promoPrice);

    if (promoInt >= priceInt) {
      return const ValidationModel(
        status: false,
        message: 'Harga promo harus lebih kecil dari harga asli',
      );
    }

    return const ValidationModel(
      status: true,
      message: 'Data valid',
    );
  }

  static ValidationModel startDate(String? startDate) {
    if (startDate == null) {
      return const ValidationModel(message: 'Date null.');
    }
    if (startDate.isEmpty || startDate.trim().isEmpty) {
      return const ValidationModel(
        message: 'Tanggal awal tidak boleh kosong.',
      );
    }

    // Membagi string menjadi tahun, bulan, dan hari
    List<String> dateParts = startDate.split('-');
    int year = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int day = int.parse(dateParts[2]);

    // Membuat objek DateTime
    DateTime selectedDate = DateTime(year, month, day);

    final DateTime today = DateTime.now();
    final DateTime fiveMonthsFromNow = today.add(const Duration(days: 5 * 30));

    // tanggal harus 1 hari dari sekarang atau setelahnya
    if (selectedDate.isBefore(today)) {
      return const ValidationModel(
        message: 'Tanggal harus satu hari atau setelahnya dari sekarang.',
        status: false,
      );
    }

    // tanggal awal maksimal 5 bulan dari sekarang
    if (selectedDate.isAfter(fiveMonthsFromNow)) {
      return const ValidationModel(
        message: 'Maksimal tanggal yang dipilih adalah 5 bulan dari sekarang.',
        status: false,
      );
    }

    return const ValidationModel(status: true, message: "Data valid");
  }

  static ValidationModel endDate(String? endDate) {
    if (endDate == null) {
      return const ValidationModel(message: 'Date null.');
    }
    if (endDate.isEmpty || endDate.trim().isEmpty) {
      return const ValidationModel(
        message: 'Tanggal awal tidak boleh kosong.',
      );
    }

    // Membagi string menjadi tahun, bulan, dan hari
    List<String> dateParts = endDate.split('-');
    int year = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int day = int.parse(dateParts[2]);

    // Membuat objek DateTime
    DateTime selectedDate = DateTime(year, month, day);

    final DateTime today = DateTime.now();
    final DateTime sixMonthsFromNow = today.add(const Duration(days: 6 * 30));

    // tanggal harus 1 hari dari sekarang atau setelahnya
    if (selectedDate.isBefore(today.add(const Duration(days: 1)))) {
      return const ValidationModel(
        message: 'Tanggal harus dua hari dari sekarang.',
        status: false,
      );
    }

    // tanggal awal maksimal 5 bulan dari sekarang
    if (selectedDate.isAfter(sixMonthsFromNow)) {
      return const ValidationModel(
        message: 'Maksimal tanggal yang dipilih adalah 5 bulan dari sekarang.',
        status: false,
      );
    }

    return const ValidationModel(status: true, message: "Data valid");
  }

  static ValidationModel konfirmasiPassword(
      String? password, String? konfirmasi) {
    if (password == null) {
      return const ValidationModel(message: 'Password null.');
    }
    if (konfirmasi == null) {
      return const ValidationModel(message: 'Konfirmasi null.');
    }

    if (password != konfirmasi) {
      // Password valid
      return const ValidationModel(
        message: 'Konfirmasi password tidak cocok',
      );
    }

    // Password valid
    return const ValidationModel(
      status: true,
      message: 'Data valid',
    );
  }

  static ValidationModel konfirmasiPin(
    String? pin,
    String? konfirmasi,
  ) {
    if (pin == null) {
      return const ValidationModel(message: 'PIN null.');
    }
    if (konfirmasi == null) {
      return const ValidationModel(message: 'Konfirmasi null.');
    }

    if (pin != konfirmasi) {
      // Password valid
      return const ValidationModel(
        message: 'Konfirmasi PIN tidak cocok',
      );
    }

    // Password valid
    return const ValidationModel(
      status: true,
      message: 'Data valid',
    );
  }
}

void main() {
  ValidationModel startDate = PasarAjaValidation.endDate('2024-04-16');

  print(startDate.message);
}

class ValidationModel extends Equatable {
  final bool? status;
  final String? message;

  const ValidationModel({
    this.status = false,
    this.message,
  });

  @override
  List<Object?> get props {
    return [
      status!,
      message!,
    ];
  }
}
