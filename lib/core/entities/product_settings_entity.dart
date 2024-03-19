import 'package:equatable/equatable.dart';

class ProductSettingsEntity extends Equatable {
  final bool? isRecommended;
  final bool? isShown;
  final bool? isAvailable;

  const ProductSettingsEntity({
    this.isRecommended,
    this.isShown,
    this.isAvailable,
  });

  @override
  List<Object?> get props {
    return [
      isRecommended,
      isShown,
      isAvailable,
    ];
  }
}