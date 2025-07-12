import 'package:ecommerce/data/order/model/product_ordered.dart';
import 'package:ecommerce/domain/order/entities/product_oredered.dart';

class OrderRegistrationReq {
  final List<ProductOrderedEntity> products;
  final String createdDate;
  final String shippingAddress;
  final int itemCount;
  final double totalPrice;
  final String code;

  OrderRegistrationReq({
    required this.products,
    required this.createdDate,
    required this.shippingAddress,
    required this.itemCount,
    required this.totalPrice,
    String? code,
  }) : code = code ?? _generateCode();

  static String _generateCode() {
    final now = DateTime.now();
    return 'OD-${now.microsecondsSinceEpoch}';
  }

  Map<String, dynamic> toMap() {
    return {
      'products': products.map((e) => e.fromEntity().toMap()).toList(),
      'createdDate': createdDate,
      'itemCount': itemCount,
      'totalPrice': totalPrice,
      'shippingAddress': shippingAddress,
      'code': code,
    };
  }
}
