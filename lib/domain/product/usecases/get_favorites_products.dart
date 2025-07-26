import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/usecase/usecase.dart';
import 'package:ecommerce/domain/product/repository/product.dart';

class GetFavoritesProductsUseCase implements UseCase<Either, dynamic> {
  final ProductRepository repository;

  GetFavoritesProductsUseCase(this.repository);

  @override
  Future<Either> call({params}) async {
    return await repository.getFavoritesProduct();
  }
}
