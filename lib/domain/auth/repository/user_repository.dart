import 'package:dartz/dartz.dart';
import '../entity/user.dart';

abstract class UserRepository {
  Future<Either<String, List<UserEntity>>> getAllUsers();
  Future<Either<String, void>> updateUserAddress(String userId, String newAddress);
  Future<Either<String, void>> updateUserPaymentMethod(String userId, String paymentMethod);
} 