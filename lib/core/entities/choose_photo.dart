import 'dart:io';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class ChoosePhotoEntity extends Equatable {
  final Uint8List? image;
  final File? imageSelected;

  const ChoosePhotoEntity({
    required this.image,
    required this.imageSelected,
  });

  @override
  List<Object?> get props {
    return [
      image,
      imageSelected,
    ];
  }
}
