import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/domain/product/entity/color.dart';

class ProductEntity {
  final String categoryId;
  final List<ProductColorEntity> colors;
  final Timestamp createdDate;
  final num discountedPrice;
  final int gender;
  final List<String> images;
  final num price;
  final String productId;
  final int salesNumber;
  final List<String> sizes;
  final String title;

  ProductEntity({
    required this.categoryId,
    required this.colors,
    required this.createdDate,
    required this.discountedPrice,
    required this.gender,
    required this.images,
    required this.price,
    required this.productId,
    required this.salesNumber,
    required this.sizes,
    required this.title,
  });
}
