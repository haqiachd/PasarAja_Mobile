import 'package:equatable/equatable.dart';

class OperationalEntity extends Equatable {
  final bool? senin;
  final bool? selasa;
  final bool? rabu;
  final bool? kamis;
  final bool? jumat;
  final bool? sabtu;
  final bool? minggu;

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
