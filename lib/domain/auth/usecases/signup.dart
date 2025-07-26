import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/usecase/usecase.dart';
import 'package:ecommerce/data/auth/models/user_creation_req.dart';
import 'package:ecommerce/domain/auth/repository/auth.dart';

class SignupUseCase implements UseCase<Either, UserCreationReq> {
  final AuthRepository repository;

  SignupUseCase(this.repository);

  @override
  Future<Either> call({UserCreationReq? params}) async {
    return await repository.signUp(params!);
  }
}
