import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/usecase/usecase.dart';
import 'package:ecommerce/domain/auth/repository/auth.dart';

class ChangePasswordUseCase implements UseCase<Either, dynamic> {
  final AuthRepository repository;
  
  ChangePasswordUseCase(this.repository);
  
  @override
  Future<Either> call({params}) async {
    return await repository.changePassword(params);
  }
} 