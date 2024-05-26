import 'dart:convert';

class EventModel {
  final int? event;
  final String? foto;
  final String? judul;
  final String? deskripsi;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  EventModel({
    this.event,
    this.foto,
    this.judul,
    this.deskripsi,
    this.createdAt,
    this.updatedAt,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
    event: json["event"],
    foto: json["foto"],
    judul: json["judul"],
    deskripsi: json["deskripsi"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "event": event,
    "foto": foto,
    "judul": judul,
    "deskripsi": deskripsi,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };

  static List<EventModel> fromList(List<dynamic> payload) {
    return payload
        .map<EventModel>(
            (dynamic i) => EventModel.fromJson(i as Map<String, dynamic>))
        .toList();
  }
}
