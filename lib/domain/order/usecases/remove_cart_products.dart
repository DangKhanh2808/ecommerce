import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/usecase/usecase.dart';
import 'package:ecommerce/domain/order/repository/order.dart';

class RemoveCartProductsUseCase implements UseCase<Either, String> {
  final OrderRepository repository;

  RemoveCartProductsUseCase(this.repository);

  @override
  Future<Either> call({String? params}) {
    return repository.removeCartProduct(params!);
  }
}
