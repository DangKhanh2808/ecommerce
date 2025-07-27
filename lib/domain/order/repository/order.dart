import 'package:dartz/dartz.dart';
import 'package:ecommerce/data/order/model/add_to_cart_req.dart';
import 'package:ecommerce/data/order/model/order_registration_req.dart';
import 'package:ecommerce/domain/order/entities/product_oredered.dart';

abstract class OrderRepository {
  Future<Either> addToCart(AddToCartReq addToCartReq);
  Future<Either> getCartProducts();
  Future<Either> removeCartProduct(String id);
  Future<Either> orderResitration(OrderRegistrationReq order);
  Future<Either> getOrders();
  Future<Either> rebuyProduct(ProductOrderedEntity product);
  Future<Either> cancelOrder(String orderId);
}
