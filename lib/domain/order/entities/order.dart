import 'package:ecommerce/domain/order/entities/order_status.dart';
import 'package:ecommerce/domain/order/entities/product_oredered.dart';

class OrderEntity {
  final List<ProductOrderedEntity> products;       // lấy từ backend field "items"
  final String createdDate;
  final String shippingAddress;
  final int itemCount;
  final double totalPrice;
  final String code;
  final String orderId;
  final List<OrderStatusEntity> orderStatus;       // lấy từ backend field "statuses"

  OrderEntity({
    required this.products,
    required this.createdDate,
    required this.shippingAddress,
    required this.itemCount,
    required this.totalPrice,
    required this.code,
    required this.orderId,
    required this.orderStatus,
  });
}
