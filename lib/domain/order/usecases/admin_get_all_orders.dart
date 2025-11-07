import 'package:dartz/dartz.dart';
import 'package:ecommerce/domain/order/repository/order.dart';
import 'package:ecommerce/service_locator.dart';

class AdminGetAllOrdersUseCase {
  AdminGetAllOrdersUseCase(OrderRepository orderRepository);

  Future<Either<String, dynamic>> call() async {
    return await sl<OrderRepository>().getAllOrders();
  }
}
