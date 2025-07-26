import 'package:ecommerce/domain/product/entity/color.dart';

class DefaultColors {
  // Danh sách 5 màu cơ bản
  static List<Map<String, dynamic>> get colors => [
    {'title': 'Black', 'rgb': [0, 0, 0]},
    {'title': 'White', 'rgb': [255, 255, 255]},
    {'title': 'Red', 'rgb': [255, 0, 0]},
    {'title': 'Blue', 'rgb': [0, 0, 255]},
    {'title': 'Green', 'rgb': [0, 128, 0]},
  ];

  // Chuyển đổi thành ProductColorEntity
  static List<ProductColorEntity> get colorEntities => colors.map((color) => ProductColorEntity(
    title: color['title'] as String, 
    rgb: List<int>.from(color['rgb'] as List)
  )).toList();
} 