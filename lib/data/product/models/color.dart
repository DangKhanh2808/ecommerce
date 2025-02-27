import 'package:ecommerce/domain/product/entity/color.dart';

class ProductColorModel {
  final String hexCode;
  final String title;

  ProductColorModel({
    required this.hexCode,
    required this.title,
  });

  Map<String, dynamic> toMap() {
    return {
      'hexCode': hexCode,
      'title': title,
    };
  }

  factory ProductColorModel.fromMap(Map<String, dynamic> map) {
    return ProductColorModel(
      hexCode: map['hexCode'] as String,
      title: map['title'] as String,
    );
  }
}

extension ProductColorXModel on ProductColorModel {
  ProductColorEntity toEntity() {
    return ProductColorEntity(
      hexCode: hexCode,
      title: title,
    );
  }
}
