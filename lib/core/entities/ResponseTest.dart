/// status : "success"
/// message : "Login Berhasil"
/// data : {"id_user":1,"phone_number":"6212345678902","email":"hakiahmad756@gmail.com","full_name":"Haqi","password":"$2y$12$chiExO3AO4h9Bi7uoTmwX.Uhdfb0Zou5T7s5a/MSk6UUXy1PALF4C","pin":"$2y$12$Coq2.5391dnHDn5V0zNruO1u24U/e1LpUZJJO1kUPdL23qWdxsHLC","level":"Pembeli","is_verified":0,"photo":null,"created_at":"2024-03-02T18:26:12.000000Z","updated_at":"2024-03-02T18:26:12.000000Z"}

class ResponseTest {
  ResponseTest({
      String status, 
      String message, 
      Data data,}){
    _status = status;
    _message = message;
    _data = data;
}

  ResponseTest.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  String _status;
  String _message;
  Data _data;
ResponseTest copyWith({  String status,
  String message,
  Data data,
}) => ResponseTest(  status: status ?? _status,
  message: message ?? _message,
  data: data ?? _data,
);
  String get status => _status;
  String get message => _message;
  Data get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data.toJson();
    }
    return map;
  }

}

/// id_user : 1
/// phone_number : "6212345678902"
/// email : "hakiahmad756@gmail.com"
/// full_name : "Haqi"
/// password : "$2y$12$chiExO3AO4h9Bi7uoTmwX.Uhdfb0Zou5T7s5a/MSk6UUXy1PALF4C"
/// pin : "$2y$12$Coq2.5391dnHDn5V0zNruO1u24U/e1LpUZJJO1kUPdL23qWdxsHLC"
/// level : "Pembeli"
/// is_verified : 0
/// photo : null
/// created_at : "2024-03-02T18:26:12.000000Z"
/// updated_at : "2024-03-02T18:26:12.000000Z"

class Data {
  Data({
      num idUser, 
      String phoneNumber, 
      String email, 
      String fullName, 
      String password, 
      String pin, 
      String level, 
      num isVerified, 
      dynamic photo, 
      String createdAt, 
      String updatedAt,}){
    _idUser = idUser;
    _phoneNumber = phoneNumber;
    _email = email;
    _fullName = fullName;
    _password = password;
    _pin = pin;
    _level = level;
    _isVerified = isVerified;
    _photo = photo;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  Data.fromJson(dynamic json) {
    _idUser = json['id_user'];
    _phoneNumber = json['phone_number'];
    _email = json['email'];
    _fullName = json['full_name'];
    _password = json['password'];
    _pin = json['pin'];
    _level = json['level'];
    _isVerified = json['is_verified'];
    _photo = json['photo'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  num _idUser;
  String _phoneNumber;
  String _email;
  String _fullName;
  String _password;
  String _pin;
  String _level;
  num _isVerified;
  dynamic _photo;
  String _createdAt;
  String _updatedAt;
Data copyWith({  num idUser,
  String phoneNumber,
  String email,
  String fullName,
  String password,
  String pin,
  String level,
  num isVerified,
  dynamic photo,
  String createdAt,
  String updatedAt,
}) => Data(  idUser: idUser ?? _idUser,
  phoneNumber: phoneNumber ?? _phoneNumber,
  email: email ?? _email,
  fullName: fullName ?? _fullName,
  password: password ?? _password,
  pin: pin ?? _pin,
  level: level ?? _level,
  isVerified: isVerified ?? _isVerified,
  photo: photo ?? _photo,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  num get idUser => _idUser;
  String get phoneNumber => _phoneNumber;
  String get email => _email;
  String get fullName => _fullName;
  String get password => _password;
  String get pin => _pin;
  String get level => _level;
  num get isVerified => _isVerified;
  dynamic get photo => _photo;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id_user'] = _idUser;
    map['phone_number'] = _phoneNumber;
    map['email'] = _email;
    map['full_name'] = _fullName;
    map['password'] = _password;
    map['pin'] = _pin;
    map['level'] = _level;
    map['is_verified'] = _isVerified;
    map['photo'] = _photo;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }

}