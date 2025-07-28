import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/payment_method_model.dart';

class PaymentMethodFirebaseService {
  final _firestore = FirebaseFirestore.instance;

  Future<List<PaymentMethodModel>> getPaymentMethods(String userId) async {
    final snapshot = await _firestore
        .collection('Users')
        .doc(userId)
        .collection('PaymentMethods')
        .get();
    return snapshot.docs
        .map((doc) => PaymentMethodModel.fromMap({...doc.data(), 'id': doc.id}))
        .toList();
  }

  Future<void> addPaymentMethod(PaymentMethodModel method) async {
    await _firestore
        .collection('Users')
        .doc(method.userId)
        .collection('PaymentMethods')
        .add(method.toMap());
  }

  Future<void> deletePaymentMethod(String methodId, String userId) async {
    await _firestore
        .collection('Users')
        .doc(userId)
        .collection('PaymentMethods')
        .doc(methodId)
        .delete();
  }
} 