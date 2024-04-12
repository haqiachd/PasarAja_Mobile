import 'package:equatable/equatable.dart';

class OperationalEntity extends Equatable {
  final String? senin;
  final String? selasa;
  final String? rabu;
  final String? kamis;
  final String? jumat;
  final String? sabtu;
  final String? minggu;

  const OperationalEntity({
    this.senin,
    this.selasa,
    this.rabu,
    this.kamis,
    this.jumat,
    this.sabtu,
    this.minggu,
  });

  @override
  List<Object?> get props {
    return [
      senin,
      selasa,
      rabu,
      kamis,
      jumat,
      sabtu,
      minggu,
    ];
  }
}
