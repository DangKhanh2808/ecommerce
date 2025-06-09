import 'package:ecommerce/core/usecase/usecase.dart';
import 'package:ecommerce/domain/auth/repository/auth.dart';
import 'package:ecommerce/service_locator.dart';

class GetRoleUseCase implements UseCase<String, dynamic> {
  @override
  Future<String> call({params}) async {
    return await sl<AuthRepository>().getRole();
  }
}
