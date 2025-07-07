import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/usecase/usecase.dart';
import 'package:ecommerce/domain/product/entity/product.dart';
import 'package:ecommerce/domain/product/repository/product.dart';
import 'package:ecommerce/service_locator.dart';

class UpdateProductUseCase
    implements UseCase<Either<Exception, void>, ProductEntity> {
  @override
  Future<Either<Exception, void>> call({ProductEntity? params}) async {
    if (params == null) {
      return Left(Exception('Product entity is null'));
    }

    try {
      await sl<ProductRepository>().updateProduct(params);
      return const Right(null); // Thành công nhưng không trả về dữ liệu
    } catch (e) {
      return Left(Exception('Failed to update product: $e'));
    }
  }
}
