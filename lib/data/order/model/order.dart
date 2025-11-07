import 'package:ecommerce/data/order/model/order_status.dart';
import 'package:ecommerce/data/order/model/product_ordered.dart';
import 'package:ecommerce/domain/order/entities/order.dart';

class OrderModel {
  final List<ProductOrderedModel> items;
  final String createdDate;
  final String shippingAddress;
  final int itemCount;
  final double totalPrice;
  final String code;
  final String orderId;
  final List<OrderStatusModel> statuses;

  OrderModel({
    required this.items,
    required this.createdDate,
    required this.shippingAddress,
    required this.itemCount,
    required this.totalPrice,
    required this.code,
    required this.orderId,
    required this.statuses,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      items: List<ProductOrderedModel>.from(
        (map['items'] as List<dynamic>? ?? [])
            .map((item) => ProductOrderedModel.fromMap(item)),
      ),
      statuses: List<OrderStatusModel>.from(
        (map['statuses'] as List<dynamic>? ?? [])
            .map((s) => OrderStatusModel.fromMap(s)),
      ),
      createdDate: map['createdDate']?.toString() ?? '',
      shippingAddress: map['shippingAddress']?.toString() ?? '',
      itemCount: map['itemCount'] as int? ?? 0,
      totalPrice: (map['totalPrice'] as num?)?.toDouble() ?? 0.0,
      code: map['code']?.toString() ?? '',
      orderId: map['id']?.toString() ?? '',
    );
  }
}

extension OrderXModel on OrderModel {
  OrderEntity toEntity() {
    return OrderEntity(
      products: items.map((e) => e.toEntity()).toList(),
      createdDate: createdDate,
      shippingAddress: shippingAddress,
      itemCount: itemCount,
      totalPrice: totalPrice,
      code: code,
      orderId: orderId,
      orderStatus: statuses.map((e) => e.toEntity()).toList(),
    );
  }
}
