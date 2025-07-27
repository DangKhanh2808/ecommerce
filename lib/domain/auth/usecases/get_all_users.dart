import 'package:dartz/dartz.dart';
import '../entity/user.dart';
import '../repository/user_repository.dart';

class GetAllUsersUseCase {
  final UserRepository repository;
  GetAllUsersUseCase(this.repository);

  Future<Either<String, List<UserEntity>>> call() {
    return repository.getAllUsers();
  }
} 