import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/data/product/models/color.dart';
import 'package:ecommerce/domain/product/entity/product.dart';

class ProductModel {
  final String categoryId;
  final List<ProductColorModel> colors;
  final Timestamp createdDate;
  final num discountedPrice;
  final int gender;
  final List<String> images;
  final num price;
  final String productId;
  final int salesNumber;
  final List<String> sizes;
  final String title;

  const ProductModel({
    required this.categoryId,
    this.colors = const [],
    required this.createdDate,
    this.discountedPrice = 0,
    this.gender = 0,
    this.images = const [],
    required this.price,
    required this.productId,
    this.salesNumber = 0,
    this.sizes = const [],
    required this.title,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      categoryId: map['categoryId'] ?? '',
      colors: (map['colors'] as List<dynamic>? ?? [68, 104, 229])
          .map((e) => ProductColorModel.fromMap(e))
          .toList(),
      createdDate: map['createdDate'] ?? Timestamp.now(),
      discountedPrice: map['discountedPrice'] ?? 0,
      gender: map['gender'] ?? 0,
      images: List<String>.from(map['images'] ?? []),
      price: map['price'] ?? 0,
      productId: map['productId'] ?? '',
      salesNumber: map['salesNumber'] ?? 0,
      sizes: List<String>.from(map['sizes'] ?? [35, 37, 40, 42]),
      title: map['title'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'categoryId': categoryId,
      'colors': colors.map((e) => e.toMap()).toList(),
      'createdDate': createdDate,
      'discountedPrice': discountedPrice,
      'gender': gender,
      'images': images,
      'price': price,
      'productId': productId,
      'salesNumber': salesNumber,
      'sizes': sizes,
      'title': title,
    };
  }

  ProductModel copyWith({
    String? categoryId,
    List<ProductColorModel>? colors,
    Timestamp? createdDate,
    num? discountedPrice,
    int? gender,
    List<String>? images,
    num? price,
    String? productId,
    int? salesNumber,
    List<String>? sizes,
    String? title,
  }) {
    return ProductModel(
      categoryId: categoryId ?? this.categoryId,
      colors: colors ?? this.colors,
      createdDate: createdDate ?? this.createdDate,
      discountedPrice: discountedPrice ?? this.discountedPrice,
      gender: gender ?? this.gender,
      images: images ?? this.images,
      price: price ?? this.price,
      productId: productId ?? this.productId,
      salesNumber: salesNumber ?? this.salesNumber,
      sizes: sizes ?? this.sizes,
      title: title ?? this.title,
    );
  }
}

extension ProductXModel on ProductModel {
  ProductEntity toEntity() {
    return ProductEntity(
      categoryId: categoryId,
      colors: colors.map((e) => e.toEntity()).toList(),
      createdDate: createdDate,
      discountedPrice: discountedPrice,
      gender: gender,
      images: images,
      price: price,
      productId: productId,
      salesNumber: salesNumber,
      sizes: sizes,
      title: title,
    );
  }
}

extension ProductXEntity on ProductEntity {
  ProductModel fromEntity() {
    return ProductModel(
      categoryId: categoryId,
      colors: colors.map((e) => e.fromEntity()).toList(),
      createdDate: createdDate,
      discountedPrice: discountedPrice,
      gender: gender,
      images: images,
      price: price,
      sizes: sizes,
      productId: productId,
      salesNumber: salesNumber,
      title: title,
    );
  }
}
