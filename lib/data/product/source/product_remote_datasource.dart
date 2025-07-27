import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

final uuid = Uuid();

Future<String> uploadImage(File file) async {
      final fileName = '${uuid.v4()}.jpg'; // ✅ Create random file name
  final ref = FirebaseStorage.instance.ref().child('products/images/$fileName');
  await ref.putFile(file);
  return await ref.getDownloadURL();
}
