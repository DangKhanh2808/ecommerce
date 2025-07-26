import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/usecase/usecase.dart';
import 'package:ecommerce/domain/order/repository/order.dart';

class GetCartProductsUseCase implements UseCase<Either, dynamic> {
  final OrderRepository repository;

  GetCartProductsUseCase(this.repository);

  @override
  Future<Either> call({params}) {
    return repository.getCartProducts();
  }
}
