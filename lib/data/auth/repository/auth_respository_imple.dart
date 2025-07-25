import 'package:dartz/dartz.dart';
import 'package:ecommerce/data/auth/models/user.dart';
import 'package:ecommerce/data/auth/models/user_creation_req.dart';
import 'package:ecommerce/data/auth/models/user_signin.dart';
import 'package:ecommerce/data/auth/sources/auth_firebase_service.dart';
import 'package:ecommerce/domain/auth/repository/auth.dart';
import 'package:ecommerce/service_locator.dart';

class AuthrepositoryImple extends AuthRepository {
  @override
  Future<Either> signUp(UserCreationReq user) async {
    return await sl<AuthFirebaseService>().signUp(user);
  }

  @override
  Future<Either> getAges() async {
    return await sl<AuthFirebaseService>().getAges();
  }

  @override
  Future<Either> signIn(UserSigninReq user) async {
    return await sl<AuthFirebaseService>().signIn(user);
  }

  @override
  Future<Either> sendPasswordResetEmail(String email) async {
    return await sl<AuthFirebaseService>().sendPasswordResetEmail(email);
  }

  @override
  Future<bool> isLoggedIn() async {
    return await sl<AuthFirebaseService>().isLoggedIn();
  }

  @override
  Future<Either> getUser() async {
    var user = await sl<AuthFirebaseService>().getUser();
    return user.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          UserModel.fromMap(data).toEntity(),
        );
      },
    );
  }

  @override
  Future<Either> signOut() async {
    return await sl<AuthFirebaseService>().signOut();
  }

  @override
  Future<String> getRole() async {
    return await sl<AuthFirebaseService>().getRole();
  }
}
