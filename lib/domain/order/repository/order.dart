import 'package:dartz/dartz.dart';
import 'package:ecommerce/data/order/model/add_to_cart_req.dart';

abstract class OderRepository {
  Future<Either> addToCart(AddToCartReq addToCartReq);
}
