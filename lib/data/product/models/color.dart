import 'package:ecommerce/domain/product/entity/color.dart';

class ProductColorModel {
  final String title;
  final List<int> rgb;

  ProductColorModel({
    required this.title,
    required this.rgb,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'rgb': rgb,
    };
  }

  factory ProductColorModel.fromMap(Map<String, dynamic> map) {
    List<int> rgbList = List<int>.from(
      map['rgb']?.map((e) => e) ?? [0, 0, 0],
    );
    
    // Đảm bảo rgb array có ít nhất 3 phần tử
    while (rgbList.length < 3) {
      rgbList.add(0);
    }
    
    return ProductColorModel(
      title: map['title'] as String? ?? 'Unknown',
      rgb: rgbList,
    );
  }
}

extension ProductColorXModel on ProductColorModel {
  ProductColorEntity toEntity() {
    return ProductColorEntity(title: title, rgb: rgb);
  }
}

extension ProductColorXEntity on ProductColorEntity {
  ProductColorModel fromEntity() {
    return ProductColorModel(title: title, rgb: rgb);
  }
}
