import 'package:dartz/dartz.dart';
import '../repository/user_repository.dart';

class UpdateUserPaymentMethodUseCase {
  final UserRepository repository;
  UpdateUserPaymentMethodUseCase(this.repository);

  Future<Either<String, void>> call(String userId, String paymentMethod) {
    return repository.updateUserPaymentMethod(userId, paymentMethod);
  }
} 