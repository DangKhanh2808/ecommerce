import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:ecommerce/data/product/models/product.dart';
import 'package:ecommerce/domain/product/entity/product.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class ProductFirebaseService {
  Future<Either> getTopSelling();
  Future<Either> getNewIn();
  Future<Either> getProductsByCategoryId(String categoryId);
  Future<Either> getProductsByTitle(String title);
  Future<Either> addOrRemoveFavoriteProduct(ProductEntity product);
  Future<bool> isFavorite(String id);
  Future<Either> getFavoritesProduct();
  Future<Either> createProduct(ProductEntity product);
  Future<Either> deleteProduct(String productId);
  Future<Either> updateProduct(ProductEntity product);
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

  @override
  Future<Either> addOrRemoveFavoriteProduct(ProductEntity product) async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      var products = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user!.uid)
          .collection('Favorites')
          .where('productId', isEqualTo: product.productId)
          .get();

      if (products.docs.isNotEmpty) {
        await products.docs.first.reference.delete();
        return const Right(false);
      } else {
        FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .collection('Favorites')
            .add(product.fromEntity().toMap());
        return const Right(true);
      }
    } catch (e) {
      return Left('Please try again');
    }
  }

  @override
  Future<bool> isFavorite(String productId) async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      var products = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user!.uid)
          .collection('Favorites')
          .where('productId', isEqualTo: productId)
          .get();

      if (products.docs.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Either> getFavoritesProduct() async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      var returnedData = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user!.uid)
          .collection('Favorites')
          .get();
      return Right(returnedData.docs.map((e) => e.data()).toList());
    } catch (e) {
      return Left('Please try again');
    }
  }

  @override
  Future<Either> createProduct(ProductEntity product) async {
    try {
      var returnedData = await FirebaseFirestore.instance
          .collection('Products')
          .add(product.fromEntity().toMap());
      await returnedData.update({'productId': returnedData.id});
      return const Right(true);
    } catch (error) {
      return Left('Failed to create product: $error');
    }
  }

  @override
  Future<Either> deleteProduct(String productId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Products')
          .doc(productId)
          .delete();
      return const Right(true);
    } catch (error) {
      return Left('Failed to delete product: $error');
    }
  }

  @override
  Future<Either> updateProduct(ProductEntity product) async {
    try {
      var productRef = FirebaseFirestore.instance
          .collection('Products')
          .doc(product.productId);
      await productRef.update(product.fromEntity().toMap());
      return const Right(true);
    } catch (error) {
      return Left('Failed to update product: $error');
    }
  }
}
