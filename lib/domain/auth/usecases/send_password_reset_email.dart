import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/usecase/usecase.dart';
import 'package:ecommerce/domain/auth/repository/auth.dart';

class SendPasswordResetEmailUseCase implements UseCase<Either, String> {
  final AuthRepository repository;

  SendPasswordResetEmailUseCase(this.repository);

  @override
  Future<Either> call({String? params}) async {
    return await repository.sendPasswordResetEmail(params!);
  }
}
