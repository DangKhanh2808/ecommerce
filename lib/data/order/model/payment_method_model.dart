import '../../../domain/order/entities/payment_method.dart';

class PaymentMethodModel extends PaymentMethod {
  PaymentMethodModel({
    required super.id,
    required super.userId,
    required super.type,
    required super.last4Digits,
    super.token,
  });

  factory PaymentMethodModel.fromMap(Map<String, dynamic> map) => PaymentMethodModel(
    id: map['id'],
    userId: map['userId'],
    type: map['type'],
    last4Digits: map['last4Digits'],
    token: map['token'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'userId': userId,
    'type': type,
    'last4Digits': last4Digits,
    'token': token,
  };

  factory PaymentMethodModel.fromEntity(PaymentMethod method) => PaymentMethodModel(
    id: method.id,
    userId: method.userId,
    type: method.type,
    last4Digits: method.last4Digits,
    token: method.token,
  );
} 