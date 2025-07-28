// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'color.dart';

class ProductEntity {
  final String docId; // Firestore document id
  final String categoryId;
  final List<ProductColorEntity> colors;
  final dynamic createdDate;
  final num discountedPrice;
  final int gender;
  final List<String> images;
  final num price;
  final String productId;
  final int salesNumber;
  final List<String> sizes;
  final String title;

  ProductEntity({
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
}
