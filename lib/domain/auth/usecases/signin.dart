import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/usecase/usecase.dart';
import 'package:ecommerce/data/auth/models/user_signin.dart';
import 'package:ecommerce/domain/auth/repository/auth.dart';

class SigninUseCase implements UseCase<Either, UserSigninReq> {
  final AuthRepository repository;

  SigninUseCase(this.repository);

  @override
  Future<Either> call({UserSigninReq? params}) async {
    return await repository.signIn(params!);
  }
}
