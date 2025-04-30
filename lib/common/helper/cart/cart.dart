import 'package:ecommerce/domain/order/entities/product_oredered.dart';

class CartHelper {
  static double calculateCartSubtotal(List<ProductOrderedEntity> products) {
    double subtotal = 0.0;
    for (var product in products) {
      subtotal = subtotal + product.totalPrice;
    }
    return subtotal;
  }
}
