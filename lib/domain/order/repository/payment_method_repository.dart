import '../entities/payment_method.dart';

abstract class PaymentMethodRepository {
  Future<List<PaymentMethod>> getPaymentMethods(String userId);
  Future<void> addPaymentMethod(PaymentMethod method);
  Future<void> deletePaymentMethod(String methodId, String userId);
} 