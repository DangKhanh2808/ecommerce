import 'dart:io';
import 'package:ecommerce/domain/storage/repository/storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart'; // 👈 new import
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
    final originalFileName = basename(filePath);
    final uniqueFileName =
        '${DateTime.now().millisecondsSinceEpoch}_$originalFileName';

    final ref = _firebaseStorage.ref().child('Products/Images/$uniqueFileName');

    await ref.putFile(file);
    return ref.name;
  }
}
