import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:ecommerce/data/order/model/add_to_cart_req.dart';
import 'package:ecommerce/data/order/model/order_registration_req.dart';
import 'package:ecommerce/domain/order/entities/product_oredered.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class OrderFirebaseService {
  Future<Either> addToCart(AddToCartReq addToCartReq);
  Future<Either> getCartProducts();
  Future<Either> removeCartProduct(String id);
  Future<Either> orderResitration(OrderRegistrationReq order);
  Future<Either> getOrders();
  Future<Either> rebuyProduct(ProductOrderedEntity product);
}

class OrderFirebaseServiceImpl extends OrderFirebaseService {
  @override
  Future<Either> addToCart(AddToCartReq addToCartReq) async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user?.uid)
          .collection('Cart')
          .add(
            addToCartReq.toMap(),
          );
      return Right(
        'Item added to cart successfully',
      );
    } catch (e) {
      return Left(
        'Please try again',
      );
    }
  }

  @override
  Future<Either> getCartProducts() async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      var returnedDate = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user!.uid)
          .collection('Cart')
          .get();

      List<Map> products = [];
      for (var item in returnedDate.docs) {
        var data = item.data();
        data.addAll({'id': item.id});
        products.add(data);
      }
      return Right(products);
    } catch (e) {
      return Left('Please try again');
    }
  }

  @override
  Future<Either> removeCartProduct(String id) async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user!.uid)
          .collection('Cart')
          .doc(id)
          .delete();
      return const Right('Product removed successfully');
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> orderResitration(OrderRegistrationReq order) async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user!.uid)
          .collection('Orders')
          .add(
            order.toMap(),
          );

      for (var item in order.products) {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .collection('Cart')
            .doc(item.id)
            .delete();
      }
      return const Right('Product removed successfully');
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> getOrders() async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      var returnedData = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user!.uid)
          .collection('Orders')
          .get();
      return Right(returnedData.docs.map((e) => e.data()).toList());
    } catch (e) {
      return Left('Please try again');
    }
  }

  @override
  Future<Either> rebuyProduct(ProductOrderedEntity product) async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      
      // Tạo AddToCartReq từ ProductOrderedEntity
      final addToCartReq = {
        'productId': product.productId,
        'productTitle': product.productTitle,
        'productQuantity': product.productQuantity,
        'productColor': product.productColor,
        'productSize': product.productSize,
        'productPrice': product.productPrice,
        'totalPrice': product.totalPrice,
        'productImage': product.productImage,
        'createdDate': DateTime.now().toIso8601String(),
      };

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user?.uid)
          .collection('Cart')
          .add(addToCartReq);
          
      return Right('Product added to cart successfully');
    } catch (e) {
      return Left('Failed to add product to cart. Please try again.');
    }
  }
}
