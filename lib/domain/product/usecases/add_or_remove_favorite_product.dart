import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/usecase/usecase.dart';
import 'package:ecommerce/domain/product/entity/product.dart';
import 'package:ecommerce/domain/product/repository/product.dart';

class AddOrRemoveFavoriteProductUseCase implements UseCase<Either, ProductEntity> {
  final ProductRepository repository;

  AddOrRemoveFavoriteProductUseCase(this.repository);

  @override
  Future<Either> call({ProductEntity? params}) async {
    return await repository.addOrRemoveFavoriteProduct(params!);
  }
}
