import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/usecase/usecase.dart';
import 'package:ecommerce/domain/order/repository/order.dart';

class CancelOrderUseCase implements UseCase<Either, Map<String, String>> {
  final OrderRepository repository;

  CancelOrderUseCase(this.repository);

  @override
  Future<Either> call({Map<String, String>? params}) {
    return repository.cancelOrder(params!['orderId']!, params['cancelReason']!);
  }
} 