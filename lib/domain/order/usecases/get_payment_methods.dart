import '../repository/payment_method_repository.dart';
import '../entities/payment_method.dart';

class GetPaymentMethodsUseCase {
  final PaymentMethodRepository repository;
  GetPaymentMethodsUseCase(this.repository);

  Future<List<PaymentMethod>> call(String userId) => repository.getPaymentMethods(userId);
} 