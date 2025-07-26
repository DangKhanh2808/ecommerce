import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/usecase/usecase.dart';
import 'package:ecommerce/data/order/model/add_to_cart_req.dart';
import 'package:ecommerce/domain/order/repository/order.dart';

class AddToCartUseCase implements UseCase<Either, AddToCartReq> {
  final OrderRepository repository;

  AddToCartUseCase(this.repository);

  @override
  Future<Either> call({AddToCartReq? params}) {
    return repository.addToCart(params!);
  }
}
