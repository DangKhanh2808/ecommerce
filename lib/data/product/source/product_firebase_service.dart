import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

abstract class ProductFirebaseService {
  Future<Either> getTopSelling();
  Future<Either> getNewIn();
  Future<Either> getProductsByCategoryId(String categoryId);
  Future<Either> getProductsByTitle(String title);
}

class ProductFirebaseServiceImpl implements ProductFirebaseService {
  @override
  Future<Either> getTopSelling() async {
    try {
      var returnedDate = await FirebaseFirestore.instance
          .collection('Products')
          .where('salesNumber', isGreaterThanOrEqualTo: 20)
          .get();
      return Right(returnedDate.docs.map((e) => e.data()).toList());
    } catch (e) {
      return Left('Please try again');
    }
  }

  @override
  Future<Either> getNewIn() async {
    try {
      var returnedDate = await FirebaseFirestore.instance
          .collection('Products')
          .where(
            'createdDate',
            isGreaterThanOrEqualTo: DateTime(2025, 1, 1),
          )
          .get();
      return Right(returnedDate.docs.map((e) => e.data()).toList());
    } catch (e) {
      return Left('Please try again');
    }
  }

  @override
  Future<Either> getProductsByCategoryId(String categoryId) async {
    try {
      var returnedDate = await FirebaseFirestore.instance
          .collection('Products')
          .where(
            'categoryId',
            isEqualTo: categoryId,
          )
          .get();
      return Right(returnedDate.docs.map((e) => e.data()).toList());
    } catch (e) {
      return Left('Please try again');
    }
  }

  @override
  Future<Either> getProductsByTitle(String title) async {
    try {
      var returnedDate = await FirebaseFirestore.instance
          .collection('Products')
          .where(
            'title',
            isGreaterThanOrEqualTo: title,
          )
          .get();
      return Right(returnedDate.docs.map((e) => e.data()).toList());
    } catch (e) {
      return Left('Please try again');
    }
  }
}
