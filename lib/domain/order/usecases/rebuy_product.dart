import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/usecase/usecase.dart';
import 'package:ecommerce/domain/order/entities/product_oredered.dart';
import 'package:ecommerce/domain/order/repository/order.dart';

class RebuyProductUseCase implements UseCase<Either, ProductOrderedEntity> {
  final OrderRepository repository;

  RebuyProductUseCase(this.repository);

  @override
  Future<Either> call({ProductOrderedEntity? params}) {
    return repository.rebuyProduct(params!);
  }
} 