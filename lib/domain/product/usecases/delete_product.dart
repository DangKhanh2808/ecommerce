import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/usecase/usecase.dart';
import 'package:ecommerce/domain/product/repository/product.dart';

class DeleteProductUseCase implements UseCase<Either, String> {
  final ProductRepository repository;

  DeleteProductUseCase(this.repository);

  @override
  Future<Either> call({String? params}) async {
    return await repository.deleteProduct(params!);
  }
}
