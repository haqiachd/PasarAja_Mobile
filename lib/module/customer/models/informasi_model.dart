import 'dart:convert';


class InformasiModel {
  final int? idInformasi;
  final String? foto;
  final String? judul;
  final String? deskripsi;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  InformasiModel({
    this.idInformasi,
    this.foto,
    this.judul,
    this.deskripsi,
    this.createdAt,
    this.updatedAt,
  });

  factory InformasiModel.fromJson(Map<String, dynamic> json) => InformasiModel(
    idInformasi: json["id_informasi"],
    foto: json["foto"],
    judul: json["judul"],
    deskripsi: json["deskripsi"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id_informasi": idInformasi,
    "foto": foto,
    "judul": judul,
    "deskripsi": deskripsi,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };

  static List<InformasiModel> fromList(List<dynamic> payload) {
    return payload
        .map<InformasiModel>(
            (dynamic i) => InformasiModel.fromJson(i as Map<String, dynamic>))
        .toList();
  }
}
