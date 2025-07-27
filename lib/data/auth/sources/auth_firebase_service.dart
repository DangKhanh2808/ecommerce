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
  Future<Either> updateUser(Map<String, dynamic> userData);
  Future<Either> changePassword(Map<String, dynamic> passwordData);
  // Thêm cho admin
  Future<Either> getAllUsers();
  Future<Either> updateUserAddress(String userId, String newAddress);
  Future<Either> updateUserPaymentMethod(String userId, String paymentMethod);
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
        'phone': '',
        'address': '',
        'role': 'user',
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
              return const Left('Email or password cannot be empty.');
    }

    try {
      final userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: user.email!,
        password: user.password!,
      );

      // ✅ Lưu vào SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        await prefs.setString('uid', firebaseUser.uid);
        await prefs.setString('email', firebaseUser.email ?? '');
        await prefs.setString('displayName', firebaseUser.displayName ?? '');
        await prefs.setString('photoURL', firebaseUser.photoURL ?? '');
        await prefs.setString('role', 'user');
        await prefs.setBool('isLoggedIn', true);
      }

              return const Right('Login successful');
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'Invalid email.';
          break;
        case 'user-not-found':
                      errorMessage = 'No account found with this email.';
          break;
        case 'wrong-password':
                      errorMessage = 'Wrong password.';
          break;
        default:
                      errorMessage = e.message ?? 'Login failed.';
      }

      return Left(errorMessage);
    } catch (e) {
              return Left('An unknown error occurred: ${e.toString()}');
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

  @override
  Future<Either> updateUser(Map<String, dynamic> userData) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        return const Left('No logged in user found');
      }

      // Update information in Firestore
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser.uid)
          .update(userData);

      // Cập nhật displayName và photoURL trong Firebase Auth nếu có
      if (userData.containsKey('firstName') && userData.containsKey('lastName')) {
        await currentUser.updateDisplayName(
          '${userData['firstName']} ${userData['lastName']}',
        );
      }

      if (userData.containsKey('image')) {
        await currentUser.updatePhotoURL(userData['image']);
      }

      return const Right('Information updated successfully');
    } catch (e) {
      return Left('Error updating information: ${e.toString()}');
    }
  }

  @override
  Future<Either> changePassword(Map<String, dynamic> passwordData) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        return const Left('No logged in user found');
      }

      final currentPassword = passwordData['currentPassword'] as String;
      final newPassword = passwordData['newPassword'] as String;

      // Re-authenticate user with current password
      final credential = EmailAuthProvider.credential(
        email: currentUser.email!,
        password: currentPassword,
      );

      await currentUser.reauthenticateWithCredential(credential);

      // Update password
      await currentUser.updatePassword(newPassword);

      return const Right('Password changed successfully');
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'wrong-password':
          errorMessage = 'Current password is incorrect';
          break;
        case 'weak-password':
          errorMessage = 'New password is too weak';
          break;
        default:
          errorMessage = 'Error changing password: ${e.message}';
      }
      return Left(errorMessage);
    } catch (e) {
      return Left('Unknown error: ${e.toString()}');
    }
  }

  @override
  Future<Either> getAllUsers() async {
    try {
      var users = await FirebaseFirestore.instance.collection('Users').get();
      return Right(users.docs.map((e) => e.data()).toList());
    } catch (e) {
      return Left('Please try again');
    }
  }

  @override
  Future<Either> updateUserAddress(String userId, String newAddress) async {
    try {
      await FirebaseFirestore.instance.collection('Users').doc(userId).update({'address': newAddress});
      return Right('Address updated');
    } catch (e) {
      return Left('Update failed');
    }
  }

  @override
  Future<Either> updateUserPaymentMethod(String userId, String paymentMethod) async {
    try {
      await FirebaseFirestore.instance.collection('Users').doc(userId).update({'paymentMethod': paymentMethod});
      return Right('Payment method updated');
    } catch (e) {
      return Left('Update failed');
    }
  }
}
