import 'package:pasaraja_mobile/core/entities/product_settings_entity.dart';

class ProductSettingsModel extends ProductSettingsEntity {
  const ProductSettingsModel({
    final bool? isRecommended,
    final bool? isShown,
    final bool? isAvailable,
  }) : super(
          isRecommended: isRecommended,
          isShown: isShown,
          isAvailable: isAvailable,
        );

  factory ProductSettingsModel.fromJson(Map<String, dynamic> json) {
    return ProductSettingsModel(
      isRecommended: json['is_recommended'] ?? false,
      isShown: json['is_shown'] ?? true,
      isAvailable: json['is_available'] ?? false,
    );
  }
}
