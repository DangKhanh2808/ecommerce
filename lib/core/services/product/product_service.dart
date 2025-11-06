import 'package:ecommerce/core/services/api_service.dart';

class ProductService {
  final ApiService api = ApiService();

  Future<List<dynamic>> getProducts() async {
    final res = await api.get("product");
    return res["products"];
  }
}
