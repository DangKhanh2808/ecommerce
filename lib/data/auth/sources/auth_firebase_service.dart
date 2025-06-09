import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:ecommerce/data/auth/models/user.dart';
import 'package:ecommerce/data/auth/models/user_creation_req.dart';
import 'package:ecommerce/data/auth/models/user_signin.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthFirebaseService {
  Future<Either> signUp(UserCreationReq user);
  Future<Either> signIn(UserSigninReq user);
  Future<Either> getAges();
  Future<Either> sendPasswordResetEmail(String email);
  Future<bool> isLoggedIn();
  Future<Either> getUser();
  Future<Either> signOut();
  Future<String> getRole();
}

class AuthFirebaseServiceImpl extends AuthFirebaseService {
  @override
  Future<Either> signUp(UserCreationReq user) async {
    try {
      var returnedDate =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: user.email!,
        password: user.password!,
      );

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(returnedDate.user!.uid)
          .set({
        'userId': returnedDate.user!.uid,
        'firstName': user.firstName,
        'lastName': user.lastName,
        'email': user.email,
        'age': user.age,
        'gender': user.gender,
        'image': returnedDate.user!.photoURL,
      });

      return Right(
        'User created successfully',
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = '';

      if (e.code == 'email-already-in-use') {
        errorMessage = 'The account already exists for that email.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else {
        errorMessage = 'An error occurred while creating the user.';
      }

      return Left(
        errorMessage,
      );
    }
  }

  @override
  Future<Either> getAges() async {
    try {
      var returnedData =
          await FirebaseFirestore.instance.collection('Ages').get();

      return Right(returnedData.docs);
    } catch (e) {
      return Left('Please try again');
    }
  }

  @override
  Future<Either<String, String>> signIn(UserSigninReq user) async {
    if (user.email == null ||
        user.password == null ||
        user.email!.isEmpty ||
        user.password!.isEmpty) {
      return const Left('Email hoặc mật khẩu không được để trống.');
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: user.email!,
        password: user.password!,
      );
      return const Right('Đăng nhập thành công');
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'Email không hợp lệ.';
          break;
        case 'user-not-found':
          errorMessage = 'Không tìm thấy tài khoản với email này.';
          break;
        case 'wrong-password':
          errorMessage = 'Sai mật khẩu.';
          break;
        default:
          errorMessage = e.message ?? 'Đăng nhập thất bại.';
      }

      return Left(errorMessage);
    } catch (e) {
      return Left('Đã xảy ra lỗi không xác định: ${e.toString()}');
    }
  }

  @override
  Future<Either> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return Right('Email sent successfully');
    } catch (e) {
      return Left('Please try again');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    if (FirebaseAuth.instance.currentUser != null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<Either> getUser() async {
    try {
      var currentUser = FirebaseAuth.instance.currentUser;
      var userData = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser?.uid)
          .get()
          .then((value) => value.data());
      return Right(userData);
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();

      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      return const Right(true);
    } catch (e) {
      return Left('Please try again');
    }
  }

  @override
  Future<String> getRole() async {
    var currentUser = FirebaseAuth.instance.currentUser;
    var userData = await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser?.uid)
        .get();

    return UserModel.fromMap(userData.data() ?? {}).toEntity().role;
  }
}
