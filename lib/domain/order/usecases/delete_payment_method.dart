import '../repository/payment_method_repository.dart';

class DeletePaymentMethodUseCase {
  final PaymentMethodRepository repository;
  DeletePaymentMethodUseCase(this.repository);

  Future<void> call(String methodId, String userId) => repository.deletePaymentMethod(methodId, userId);
} 