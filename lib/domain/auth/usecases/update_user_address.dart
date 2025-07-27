import 'package:dartz/dartz.dart';
import '../repository/user_repository.dart';

class UpdateUserAddressUseCase {
  final UserRepository repository;
  UpdateUserAddressUseCase(this.repository);

  Future<Either<String, void>> call(String userId, String newAddress) {
    return repository.updateUserAddress(userId, newAddress);
  }
} 