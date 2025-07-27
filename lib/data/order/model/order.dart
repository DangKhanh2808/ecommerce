import 'package:ecommerce/data/order/model/order_status.dart';
import 'package:ecommerce/data/order/model/product_ordered.dart';
import 'package:ecommerce/domain/order/entities/order.dart';

class OrderModel {
  final List<ProductOrderedModel> products;
  final String createdDate;
  final String shippingAddress;
  final int itemCount;
  final double totalPrice;
  final String code;
  final String orderId;
  final List<OrderStatusModel> orderStatus;

  OrderModel({
    required this.products,
    required this.createdDate,
    required this.shippingAddress,
    required this.itemCount,
    required this.totalPrice,
    required this.code,
    required this.orderId,
    required this.orderStatus,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      products: List<ProductOrderedModel>.from(
        (map['products'] as List<dynamic>? ?? [])
            .map((product) => ProductOrderedModel.fromMap(product)),
      ),
      createdDate: map['createdDate']?.toString() ?? '',
      shippingAddress: map['shippingAddress']?.toString() ?? '',
      itemCount: map['itemCount'] as int? ?? 0,
      totalPrice: (map['totalPrice'] as num?)?.toDouble() ?? 0.0,
      code: map['code']?.toString() ?? '',
      orderId: map['orderId']?.toString() ?? '',
      orderStatus: (map['orderStatus'] as List<dynamic>?)
              ?.map((status) => OrderStatusModel.fromMap(status))
              .toList() ??
          [],
    );
  }
}

extension OrderXModel on OrderModel {
  OrderEntity toEntity() {
    return OrderEntity(
      products: products.map((e) => e.toEntity()).toList(),
      createdDate: createdDate,
      shippingAddress: shippingAddress,
      itemCount: itemCount,
      totalPrice: totalPrice,
      code: code,
      orderId: orderId,
      orderStatus: orderStatus.map((e) => e.toEntity()).toList(),
    );
  }
}
