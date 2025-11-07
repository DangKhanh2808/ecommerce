import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/data/order/model/order_status.dart';
import 'package:ecommerce/data/order/model/product_ordered.dart';
import 'package:ecommerce/domain/order/entities/product_oredered.dart';

class OrderRegistrationReq {
  final List<ProductOrderedEntity> products;
  final String createdDate;
  final String shippingAddress;
  final int itemCount;
  final double totalPrice;
  final String code;
  final String orderId;
  final List<OrderStatusModel> orderStatus;

  OrderRegistrationReq({
    required this.products,
    required this.createdDate,
    required this.shippingAddress,
    required this.itemCount,
    required this.totalPrice,
    String? code,
    String? orderId,
    List<OrderStatusModel>? orderStatus,
  })  : code = code ?? _generateCode(),
        orderId = orderId ?? _generateOrderId(),
        orderStatus = orderStatus ?? _generateInitialOrderStatus();

  static String _generateCode() {
    final now = DateTime.now();
    return 'OD-${now.microsecondsSinceEpoch}';
  }

  static String _generateOrderId() {
    final now = DateTime.now();
    return 'ORDER-${now.millisecondsSinceEpoch}';
  }

  static List<OrderStatusModel> _generateInitialOrderStatus() {
    final now = Timestamp.now();
    return [
      OrderStatusModel(
        title: 'Order Placed',
        done: true,
        createdDate: DateTime.now(),
      ),
      OrderStatusModel(
        title: 'Processing',
        done: true,
        createdDate: DateTime.now(),
      ),
      OrderStatusModel(
        title: 'Shipped',
        done: false,
        createdDate: DateTime.now(),
      ),
      OrderStatusModel(
        title: 'Delivered',
        done: false,
        createdDate: DateTime.now(),
      ),
    ];
  }

  Map<String, dynamic> toMap() {
    return {
      'products': products.map((e) => e.fromEntity().toMap()).toList(),
      'createdDate': createdDate,
      'itemCount': itemCount,
      'totalPrice': totalPrice,
      'shippingAddress': shippingAddress,
      'code': code,
      'orderId': orderId,
      'orderStatus': orderStatus.map((e) => e.toMap()).toList(),
    };
  }

  Map<String, dynamic> toBackendJson(String userId) {
    return {
      "userId": userId,
      "shippingAddress": shippingAddress,
      "totalPrice": totalPrice,
      "items": products.map((p) {
        return {
          "productDocId": p.productId,
          "productTitle": p.productTitle,
          "productImage": p.productImage,
          "productSize": p.productSize,
          "productColor": p.productColor,
          "productPrice": p.productPrice,
          "productQuantity": p.productQuantity,
          "totalPrice": p.totalPrice,
        };
      }).toList()
    };
  }
}
