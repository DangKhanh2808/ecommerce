import 'package:ecommerce/core/usecase/usecase.dart';
import 'package:ecommerce/domain/storage/repository/storage.dart';

class UploadProductImageUseCase implements UseCase<String, String> {
  final StorageRepository repository;

  UploadProductImageUseCase(this.repository);

  @override
  Future<String> call({String? params}) async {
    try {
      if (params == null) {
        throw Exception('File path is required');
      }
      final url = await repository.uploadProductImage(filePath: params);
      return url;
    } catch (e) {
      throw Exception('Upload failed: $e');
    }
  }
}
