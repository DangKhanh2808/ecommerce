import 'package:ecommerce/domain/order/entities/product_oredered.dart';

class CartHelper {
  static double calculateCartSubtotal(List<ProductOrderedEntity> products) {
    double subtotal = 0.0;
    for (var product in products) {
      subtotal = subtotal + product.totalPrice;
    }
    return subtotal;
  }

  static double calculateShippingCost(List<ProductOrderedEntity> products) {
    double subtotal = calculateCartSubtotal(products);
    if (subtotal >= 500) {
      return 0.0;
    }
    int totalQuantity = 0;
    for (var product in products) {
      totalQuantity += product.productQuantity;
    }
    return 20.0 * totalQuantity;
  }
}
