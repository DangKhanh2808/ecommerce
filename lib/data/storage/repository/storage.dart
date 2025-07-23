import 'dart:io';
import 'package:ecommerce/domain/storage/repository/storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageRepositoryImpl implements StorageRepository {
  final FirebaseStorage _firebaseStorage;
  final Uuid _uuid;

  StorageRepositoryImpl({
    FirebaseStorage? firebaseStorage,
    Uuid? uuid,
  })  : _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance,
        _uuid = uuid ?? Uuid();

  @override
  Future<String> uploadProductImage({required String filePath}) async {
    final file = File(filePath);
    final fileName = '${_uuid.v4()}.jpg';
    final ref = _firebaseStorage.ref().child('products/images/$fileName');

    await ref.putFile(file);
    return await ref.getDownloadURL(); // ✅ Link dùng để lưu vào Firestore
  }
}
