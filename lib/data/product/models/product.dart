import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/data/product/models/color.dart';
import 'package:ecommerce/domain/product/entity/product.dart';

class ProductModel {
  final String docId; // Firestore document id
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
    required this.docId,
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

  factory ProductModel.fromMap(Map<String, dynamic> map, String docId) {
    // Defensive: ensure all fields are present and correct type
    List<ProductColorModel> safeColors = [];
    try {
      if (map['colors'] is List) {
        safeColors = (map['colors'] as List)
            .where((e) => e != null)
            .map((e) => ProductColorModel.fromMap(e ?? {}))
            .toList();
      }
    } catch (_) {
      safeColors = [];
    }
    List<String> safeImages = [];
    try {
      if (map['images'] is List) {
        safeImages = List<String>.from(map['images'].whereType<String>());
      }
    } catch (_) {
      safeImages = [];
    }
    List<String> safeSizes = [];
    try {
      if (map['sizes'] is List) {
        safeSizes = List<String>.from(map['sizes'].map((e) => e.toString()));
      }
    } catch (_) {
      safeSizes = ['35', '37', '40', '42'];
    }
    return ProductModel(
      docId: docId,
      categoryId: map['categoryId']?.toString() ?? '',
      colors: safeColors,
      createdDate: map['createdDate'] ?? Timestamp.now(),
      discountedPrice: num.tryParse(map['discountedPrice']?.toString() ?? '0') ?? 0,
      gender: int.tryParse(map['gender']?.toString() ?? '0') ?? 0,
      images: safeImages,
      price: num.tryParse(map['price']?.toString() ?? '0') ?? 0,
      productId: map['productId']?.toString() ?? '',
      salesNumber: int.tryParse(map['salesNumber']?.toString() ?? '0') ?? 0,
      sizes: safeSizes,
      title: map['title']?.toString() ?? '',
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
    String? docId,
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
      docId: docId ?? this.docId,
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
      docId: docId,
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
      docId: docId,
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
