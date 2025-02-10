import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/usecase/usecase.dart';
import 'package:ecommerce/domain/auth/respository/auth.dart';
import 'package:ecommerce/service_locator.dart';

class SendPasswordResetEmailUseCase implements Usecase<Either, String> {
  @override
  Future<Either> call({String? params}) async {
    return await sl<AuthRepository>().sendPasswordResetEmail(params!);
  }
}
