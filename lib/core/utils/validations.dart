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

    // Phone harus diatara 9-15 karakter
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

  static ValidationModel price(String price) {
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
