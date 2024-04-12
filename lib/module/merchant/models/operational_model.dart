import 'package:pasaraja_mobile/core/entities/operational_entity.dart';

class OperationalModel extends OperationalEntity {
  const OperationalModel({
    final String? senin,
    final String? selasa,
    final String? rabu,
    final String? kamis,
    final String? jumat,
    final String? sabtu,
    final String? minggu,
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
      senin: json['senin'] ?? '',
    );
  }
}
