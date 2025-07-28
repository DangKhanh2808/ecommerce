import '../repository/payment_method_repository.dart';
import '../entities/payment_method.dart';

class AddPaymentMethodUseCase {
  final PaymentMethodRepository repository;
  AddPaymentMethodUseCase(this.repository);

  Future<void> call(PaymentMethod method) => repository.addPaymentMethod(method);
} 