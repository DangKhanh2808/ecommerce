import 'package:ecommerce/data/order/model/product_ordered.dart';
import 'package:ecommerce/domain/order/entities/product_oredered.dart';

class OrderRegistrationReq {
  final List<ProductOrderedEntity> products;
  final String createdDate;
  final String shippingAddress;
  final int itemCount;
  final double totalPrice;

  OrderRegistrationReq({
    required this.shippingAddress,
    required this.products,
    required this.createdDate,
    required this.itemCount,
    required this.totalPrice,
  });

  Map<String, dynamic> toMap() {
    return {
      'products': products.map((e) => e.fromEntity().toMap()).toList(),
      'createdDate': createdDate,
      'itemCount': itemCount,
      'totalPrice': totalPrice,
      'shippingAddress': shippingAddress,
    };
  }
}
