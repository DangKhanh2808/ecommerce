import 'package:dartz/dartz.dart';
import '../entity/product.dart';
import '../repository/product.dart';

class GetRelatedProductsUseCase {
  final ProductRepository repository;
  GetRelatedProductsUseCase(this.repository);

  Future<Either<String, List<ProductEntity>>> call({required String categoryId, required String excludeProductId}) {
    return repository.getRelatedProducts(categoryId: categoryId, excludeProductId: excludeProductId);
  }
} 