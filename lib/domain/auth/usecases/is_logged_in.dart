import 'package:ecommerce/core/usecase/usecase.dart';
import 'package:ecommerce/domain/auth/repository/auth.dart';

class IsLoggedInUseCase implements UseCase<bool, dynamic> {
  final AuthRepository repository;

  IsLoggedInUseCase(this.repository);

  @override
  Future<bool> call({params}) async {
    return await repository.isLoggedIn();
  }
}
