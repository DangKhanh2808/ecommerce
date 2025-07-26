import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/usecase/usecase.dart';
import 'package:ecommerce/domain/order/repository/order.dart';

class GetOrdersUseCase implements UseCase<Either, dynamic> {
  final OrderRepository repository;

  GetOrdersUseCase(this.repository);

  @override
  Future<Either> call({params}) {
    return repository.getOrders();
  }
}
