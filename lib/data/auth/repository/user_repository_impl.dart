import 'package:dartz/dartz.dart';
import 'package:ecommerce/domain/auth/entity/user.dart';
import 'package:ecommerce/domain/auth/repository/user_repository.dart';
import 'package:ecommerce/data/auth/sources/auth_firebase_service.dart';
import 'package:ecommerce/service_locator.dart';

class UserRepositoryImpl extends UserRepository {
  final AuthFirebaseService _firebaseService = sl<AuthFirebaseService>();

  @override
  Future<Either<String, List<UserEntity>>> getAllUsers() async {
    final result = await _firebaseService.getAllUsers();
    return result.fold(
      (error) => Left(error.toString()),
      (data) {
        final users = (data as List)
            .map((e) => UserEntity(
                  userId: e['userId'] ?? '',
                  email: e['email'] ?? '',
                  firstName: e['firstName'] ?? '',
                  lastName: e['lastName'] ?? '',
                  gender: e['gender'] ?? 0,
                  image: e['image'] ?? '',
                  role: e['role'] ?? '',
                  phone: e['phone'],
                  address: e['address'],
                  paymentMethod: e['paymentMethod'],
                ))
            .toList();
        return Right(users);
      },
    );
  }

  @override
  Future<Either<String, void>> updateUserAddress(String userId, String newAddress) async {
    final result = await _firebaseService.updateUserAddress(userId, newAddress);
    return result.fold(
      (error) => Left(error.toString()),
      (_) => const Right(null),
    );
  }

  @override
  Future<Either<String, void>> updateUserPaymentMethod(String userId, String paymentMethod) async {
    final result = await _firebaseService.updateUserPaymentMethod(userId, paymentMethod);
    return result.fold(
      (error) => Left(error.toString()),
      (_) => const Right(null),
    );
  }
} 