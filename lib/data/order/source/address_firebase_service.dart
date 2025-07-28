import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/address_model.dart';

class AddressFirebaseService {
  final _firestore = FirebaseFirestore.instance;

  Future<List<AddressModel>> getAddresses(String userId) async {
    final snapshot = await _firestore
        .collection('Users')
        .doc(userId)
        .collection('Addresses')
        .get();
    return snapshot.docs
        .map((doc) => AddressModel.fromMap({...doc.data(), 'id': doc.id}))
        .toList();
  }

  Future<void> addAddress(AddressModel address) async {
    await _firestore
        .collection('Users')
        .doc(address.userId)
        .collection('Addresses')
        .add(address.toMap());
  }

  Future<void> updateAddress(AddressModel address) async {
    await _firestore
        .collection('Users')
        .doc(address.userId)
        .collection('Addresses')
        .doc(address.id)
        .update(address.toMap());
  }

  Future<void> deleteAddress(String addressId, String userId) async {
    await _firestore
        .collection('Users')
        .doc(userId)
        .collection('Addresses')
        .doc(addressId)
        .delete();
  }
} 