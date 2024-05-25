import 'package:pasaraja_mobile/core/entities/operational_entity.dart';

class OperationalModel extends OperationalEntity {
  const OperationalModel({
    final bool? senin,
    final bool? selasa,
    final bool? rabu,
    final bool? kamis,
    final bool? jumat,
    final bool? sabtu,
    final bool? minggu,
  }) : super(
    senin: senin,
    selasa: selasa,
    rabu: rabu,
    kamis: kamis,
    jumat: jumat,
    sabtu: sabtu,
    minggu: minggu,
  );

  factory OperationalModel.fromJson(Map<String, dynamic> json) {
    return OperationalModel(
      senin: json['Senin'] ?? false,
      selasa: json['Selasa'] ?? false,
      rabu: json['Rabu'] ?? false,
      kamis: json['Kamis'] ?? false,
      jumat: json['Jumat'] ?? false,
      sabtu: json['Sabtu'] ?? false,
      minggu: json['Minggu'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Senin': senin,
      'Selasa': selasa,
      'Rabu': rabu,
      'Kamis': kamis,
      'Jumat': jumat,
      'Sabtu': sabtu,
      'Minggu': minggu,
    };
  }
}
