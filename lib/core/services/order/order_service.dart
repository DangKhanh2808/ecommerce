import 'package:ecommerce/core/services/api_service.dart';

class OrderService {
  final ApiService api = ApiService();

  Future<Map<String, dynamic>> checkout(Map<String, dynamic> checkoutData) async {
    return await api.post("order/checkout", checkoutData);
  }
}
