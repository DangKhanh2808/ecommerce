import 'package:ecommerce/core/services/api_service.dart';

class UserService {
  final ApiService api = ApiService();

  Future<Map<String, dynamic>> getUser(int id) async {
    return await api.get("user/$id");
  }
}
