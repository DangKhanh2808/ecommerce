import 'dart:convert';

import 'package:ecommerce/domain/category/entity/category.dart';

class CategoryModel {
  final String title;
  final String image;
  final String categoryId;

  CategoryModel({
    required this.title,
    required this.image,
    required this.categoryId,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      title: map['title'] as String,
      image: map['image'] as String,
      categoryId: map['categoryId'] as String,
    );
  }

  Map<String, dynamic> toMap() => {
        "title": title,
        "image": image,
        "categoryId": categoryId,
      };

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(String source) =>
      CategoryModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

extension CategoryXModel on CategoryModel {
  CategoryEntity toEntity() {
    return CategoryEntity(
      categoryId: categoryId,
      title: title,
      image: image,
    );
  }
}
