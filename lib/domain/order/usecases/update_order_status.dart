import 'package:dartz/dartz.dart';
import 'package:ecommerce/domain/order/repository/order.dart';
import 'package:ecommerce/service_locator.dart';

class UpdateOrderStatusUseCase {
  UpdateOrderStatusUseCase(OrderRepository orderRepository);

  Future<Either<String, String>> call({
    required String code,
    required String status,
    String? note,
  }) {
    return sl<OrderRepository>().updateOrderStatus(
      code: code,
      status: status,
      note: note,
    );
  }
}
