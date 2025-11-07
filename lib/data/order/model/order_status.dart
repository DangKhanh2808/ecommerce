import 'package:ecommerce/domain/order/entities/order_status.dart';

class OrderStatusModel {
  final String title;
  final bool done;
  final DateTime createdDate;
  final String? note;

  OrderStatusModel({
    required this.title,
    required this.done,
    required this.createdDate,
    this.note,
  });

  factory OrderStatusModel.fromMap(Map<String, dynamic> map) {
    return OrderStatusModel(
      title: map['title'] ?? "",
      done: map['done'] ?? false,
      createdDate: DateTime.tryParse(map['createdDate']?.toString() ?? "") ?? DateTime.now(),
      note: map['note'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "done": done,
      "createdDate": createdDate.toIso8601String(),
      "note": note,
    };
  }
}

extension OrderStatusMapper on OrderStatusModel {
  OrderStatusEntity toEntity() {
    return OrderStatusEntity(
      title: title,
      done: done,
      createdDate: createdDate,
      note: note,
    );
  }
}

