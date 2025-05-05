import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/usecase/usecase.dart';
import 'package:ecommerce/domain/product/entity/product.dart';
import 'package:ecommerce/domain/product/repository/product.dart';
import 'package:ecommerce/service_locator.dart';

class AddOrRemoveFavoriteProductUseCase
    implements UseCase<Either, ProductEntity> {
  @override
  Future<Either> call({dynamic params}) async {
    return await sl<ProductRepository>().addOrRemoveFavoriteProduct(params!);
  }
}
