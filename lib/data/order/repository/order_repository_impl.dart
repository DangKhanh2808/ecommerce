import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:ecommerce/data/order/model/add_to_cart_req.dart';
import 'package:ecommerce/data/order/model/order.dart';
import 'package:ecommerce/data/order/model/order_registration_req.dart';
import 'package:ecommerce/data/order/model/product_ordered.dart';
import 'package:ecommerce/data/order/source/order_firebase_service.dart';
import 'package:ecommerce/domain/order/entities/product_oredered.dart';
import 'package:ecommerce/domain/order/repository/order.dart';
import 'package:ecommerce/service_locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class OrderRepositoryImpl extends OrderRepository {
  // ✅ Flutter không truy cập được localhost
  // Android emulator => 10.0.2.2
  final String baseUrl = "http://10.0.2.2:5235/api";

  @override
  Future<Either> orderResitration(OrderRegistrationReq order) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        return Left("User not logged in");
      }

      final url = Uri.parse("$baseUrl/order");

      final body = jsonEncode(order.toBackendJson(userId));
      print("📤 Sending order to backend: $body");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      print("✅ Backend response: ${response.statusCode}");
      print("✅ Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(jsonDecode(response.body));
      }

      return Left("Order failed ${response.statusCode}: ${response.body}");
    } catch (e) {
      print("❌ Order error: $e");
      return Left("Order error: $e");
    }
  }

  // ✅ Firebase Cart (vẫn giữ nguyên vì bạn đã implement rồi)
  @override
  Future<Either> addToCart(AddToCartReq addToCartReq) {
    return sl<OrderFirebaseService>().addToCart(addToCartReq);
  }

  @override
  Future<Either> getCartProducts() async {
    var returnedData = await sl<OrderFirebaseService>().getCartProducts();
    return returnedData.fold(
      (error) => Left(error),
      (data) => right(
        List.from(data)
            .map((e) => ProductOrderedModel.fromMap(e).toEntity())
            .toList(),
      ),
    );
  }

  @override
  Future<Either> removeCartProduct(String id) async {
    var returnedData = await sl<OrderFirebaseService>().removeCartProduct(id);
    return returnedData.fold(
      (error) => Left(error),
      (message) => Right(message),
    );
  }

  @override
  Future<Either> getOrders() async {
    var returnedData = await sl<OrderFirebaseService>().getOrders();
    return returnedData.fold(
      (error) => Left(error),
      (data) => right(
        List.from(data)
            .map((e) => OrderModel.fromMap(e).toEntity())
            .toList(),
      ),
    );
  }

  @override
  Future<Either> rebuyProduct(ProductOrderedEntity product) async {
    var returnedData = await sl<OrderFirebaseService>().rebuyProduct(product);
    return returnedData.fold(
      (error) => Left(error),
      (message) => Right(message),
    );
  }

  @override
  Future<Either> cancelOrder(String orderId, String cancelReason) async {
    var returnedData =
        await sl<OrderFirebaseService>().cancelOrder(orderId, cancelReason);
    return returnedData.fold(
      (error) => Left(error),
      (message) => Right(message),
    );
  }
}
