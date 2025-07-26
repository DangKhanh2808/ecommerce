import 'package:ecommerce/core/usecase/usecase.dart';
import 'package:ecommerce/domain/product/repository/product.dart';

class IsFavoriteUseCase implements UseCase<bool, String> {
  final ProductRepository repository;

  IsFavoriteUseCase(this.repository);

  @override
  Future<bool> call({String? params}) async {
    return await repository.isFavorite(params!);
  }
}
