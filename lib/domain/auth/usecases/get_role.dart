import 'package:ecommerce/core/usecase/usecase.dart';
import 'package:ecommerce/domain/auth/repository/auth.dart';

class GetRoleUseCase implements UseCase<String, dynamic> {
  final AuthRepository repository;

  GetRoleUseCase(this.repository);

  @override
  Future<String> call({params}) async {
    return await repository.getRole();
  }
}
