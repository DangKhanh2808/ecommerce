// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:ecommerce/domain/order/entities/product_oredered.dart';

class ProductOrderedModel {
  final String productId;
  final String productTitle;
  final int productQuantity;
  final String productColor;
  final String productSize;
  final double productPrice;
  final double totalPrice;
  final String productImage;
  final String createdDate;
  final String id;
  final String code;

  ProductOrderedModel({
    required this.productId,
    required this.productTitle,
    required this.productQuantity,
    required this.productColor,
    required this.productSize,
    required this.productPrice,
    required this.totalPrice,
    required this.productImage,
    required this.createdDate,
    required this.id,
    required this.code,
  });

  factory ProductOrderedModel.fromMap(Map<String, dynamic> map) {
    return ProductOrderedModel(
      productId: map['productId']?.toString() ?? '',
      productTitle: map['productTitle']?.toString() ?? '',
      productQuantity: map['productQuantity'] ?? 0,
      productColor: map['productColor']?.toString() ?? '',
      productSize: map['productSize']?.toString() ?? '',
      productPrice: (map['productPrice'] as num?)?.toDouble() ?? 0.0,
      totalPrice: (map['totalPrice'] as num?)?.toDouble() ?? 0.0,
      productImage: map['productImage']?.toString() ?? '',
      createdDate: map['createdDate']?.toString() ?? '',
      id: map['id']?.toString() ?? '',
      code: map['code']?.toString() ?? '', // nếu bạn có thêm field code
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productTitle': productTitle,
      'productQuantity': productQuantity,
      'productColor': productColor,
      'productSize': productSize,
      'productPrice': productPrice,
      'totalPrice': totalPrice,
      'productImage': productImage,
      'createdDate': createdDate,
      'id': id,
      'code': code,
    };
  }
}

extension ProductOrderedXModel on ProductOrderedModel {
  ProductOrderedEntity toEntity() {
    return ProductOrderedEntity(
      productId: productId,
      productTitle: productTitle,
      productQuantity: productQuantity,
      productColor: productColor,
      productSize: productSize,
      productPrice: productPrice,
      totalPrice: totalPrice,
      productImage: productImage,
      createdDate: createdDate,
      id: id,
      code: code,
    );
  }
}

extension ProductOrderedXEntity on ProductOrderedEntity {
  ProductOrderedModel fromEntity() {
    return ProductOrderedModel(
      productId: productId,
      productTitle: productTitle,
      productQuantity: productQuantity,
      productColor: productColor,
      productSize: productSize,
      productPrice: productPrice,
      totalPrice: totalPrice,
      productImage: productImage,
      createdDate: createdDate,
      id: id,
      code:
          'SP-$productId-${DateTime.now().millisecondsSinceEpoch}', // generate here
    );
  }
}
