import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/usecase/usecase.dart';
import 'package:ecommerce/data/order/model/order_registration_req.dart';
import 'package:ecommerce/domain/order/repository/order.dart';

class OrderRegistrationUseCase implements UseCase<Either, OrderRegistrationReq> {
  final OrderRepository repository;

  OrderRegistrationUseCase(this.repository);

  @override
  Future<Either> call({OrderRegistrationReq? params}) {
    return repository.orderResitration(params!);
  }
}
