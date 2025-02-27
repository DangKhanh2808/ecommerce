import 'package:dartz/dartz.dart';

abstract class ProductFirebaseService {
  Future<Either> getProducts();
}

class ProductFirebaseServiceImpl implements ProductFirebaseService {
  @override
  Future<Either> getProducts() {
    // TODO: implement getProducts
    throw UnimplementedError();
  }
}
