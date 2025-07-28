class PaymentMethod {
  final String id;
  final String userId;
  final String type; // 'card', 'paypal', ...
  final String last4Digits;
  final String? token;

  PaymentMethod({
    required this.id,
    required this.userId,
    required this.type,
    required this.last4Digits,
    this.token,
  });
} 