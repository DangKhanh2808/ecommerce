import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/usecase/usecase.dart';
import 'package:ecommerce/domain/product/repository/product.dart';

class GetProductsByCategoryIdUseCase implements UseCase<Either, String> {
  final ProductRepository repository;

  GetProductsByCategoryIdUseCase(this.repository);

  @override
  Future<Either> call({String? params}) async {
    return await repository.getProductsByCategoryId(params!);
  }
}
