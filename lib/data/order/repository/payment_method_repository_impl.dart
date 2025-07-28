import '../../../domain/order/entities/payment_method.dart';
import '../../../domain/order/repository/payment_method_repository.dart';
import '../model/payment_method_model.dart';
import '../source/payment_method_firebase_service.dart';

class PaymentMethodRepositoryImpl implements PaymentMethodRepository {
  final PaymentMethodFirebaseService service;
  PaymentMethodRepositoryImpl(this.service);

  @override
  Future<List<PaymentMethod>> getPaymentMethods(String userId) async {
    return await service.getPaymentMethods(userId);
  }

  @override
  Future<void> addPaymentMethod(PaymentMethod method) async {
    await service.addPaymentMethod(PaymentMethodModel.fromEntity(method));
  }

  @override
  Future<void> deletePaymentMethod(String methodId, String userId) async {
    await service.deletePaymentMethod(methodId, userId);
  }
} 