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
  /// ✅ Android emulator → backend
  final String baseUrl = "http://10.0.2.2:5235/api";

  // ---------------------------------------------------------------------------
  // ✅ 1. CREATE ORDER (backend)
  // ---------------------------------------------------------------------------
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

  // ---------------------------------------------------------------------------
  // ✅ 2. GET ALL ORDERS FOR CURRENT USER (backend)
  // ---------------------------------------------------------------------------
  @override
  Future<Either> getOrders() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return Left("User not logged in");

      final url = Uri.parse("$baseUrl/order/user/$userId");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final list = jsonDecode(response.body) as List;

        return Right(
          list.map((e) => OrderModel.fromMap(e).toEntity()).toList(),
        );
      }

      return Left("Get orders failed (${response.statusCode})");
    } catch (e) {
      return Left("Get orders error: $e");
    }
  }

  // ---------------------------------------------------------------------------
  // ✅ 3. GET ORDER BY CODE (backend)
  // ---------------------------------------------------------------------------
  @override
  Future<Either> getOrderDetails(String code) async {
    try {
      final url = Uri.parse("$baseUrl/order/$code");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return Right(OrderModel.fromMap(jsonDecode(response.body)).toEntity());
      }

      return Left("Get detail failed (${response.statusCode})");
    } catch (e) {
      return Left("Get detail error: $e");
    }
  }

  // ---------------------------------------------------------------------------
  // ✅ 4. CANCEL ORDER (backend)
  // ---------------------------------------------------------------------------
  @override
  Future<Either> cancelOrder(String orderCode, String cancelReason) async {
    try {
      final url = Uri.parse("$baseUrl/order/$orderCode/cancel");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"reason": cancelReason}),
      );

      if (response.statusCode == 204 || response.statusCode == 200) {
        return Right("Cancelled");
      }

      return Left("Cancel failed (${response.statusCode})");
    } catch (e) {
      return Left("Cancel error: $e");
    }
  }

  @override
  Future<Either<String, String>> updateOrderStatus({
    required String code,
    required String status,
    String? note,
  }) async {
    try {
      final url = Uri.parse("$baseUrl/order/$code/status");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "status": status,
          "note": note,
        }),
      );

      if (response.statusCode == 200) {
        return const Right("OK");
      } else {
        return Left("Failed: ${response.statusCode}");
      }
    } catch (e) {
      return Left("Error: $e");
    }
  }

  @override
  Future<Either<String, dynamic>> getAllOrders() async {
    try {
      final url = Uri.parse("$baseUrl/order");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final list = jsonDecode(response.body) as List;

        return Right(
          list.map((e) => OrderModel.fromMap(e).toEntity()).toList(),
        );
      }

      return Left("Failed (${response.statusCode})");
    } catch (e) {
      return Left("Error: $e");
    }
  }

  // ---------------------------------------------------------------------------
  // ✅ Firebase Cart STILL USED (unchanged)
  // ---------------------------------------------------------------------------

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
  Future<Either> rebuyProduct(ProductOrderedEntity product) async {
    return Left("Rebuy not supported in backend yet");
  }
}
