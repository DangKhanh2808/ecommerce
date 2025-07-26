import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/usecase/usecase.dart';
import 'package:ecommerce/domain/auth/repository/auth.dart';

class GetUserUseCase implements UseCase<Either, dynamic> {
  final AuthRepository repository;

  GetUserUseCase(this.repository);

  @override
  Future<Either> call({dynamic params}) async {
    return await repository.getUser();
  }
}
