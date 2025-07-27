import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/domain/order/entities/order_status.dart';

class OrderStatusModel {
  final String title;
  final bool done;
  final Timestamp createdDate;

  OrderStatusModel({
    required this.title,
    required this.done,
    required this.createdDate,
  });

  factory OrderStatusModel.fromMap(Map<String, dynamic> map) {
    return OrderStatusModel(
      title: map['title']?.toString() ?? '',
      done: map['done'] as bool? ?? false,
      createdDate: map['createdDate'] as Timestamp? ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'done': done,
      'createdDate': createdDate,
    };
  }
}

extension OrderStatusXModel on OrderStatusModel {
  OrderStatusEntity toEntity() {
    return OrderStatusEntity(
      title: title,
      done: done,
      createdDate: createdDate,
    );
  }
}
