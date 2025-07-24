import 'dart:io';
import 'package:ecommerce/domain/storage/repository/storage.dart';
import 'package:ecommerce/presentation/product/bloc/image/image_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImagePickerCubit extends Cubit<ImagePickerState> {
  final StorageRepository _storageRepository;

  ImagePickerCubit(this._storageRepository) : super(const ImagePickerState());

  void setLoading(bool value) => emit(state.copyWith(loading: value));

  void addImage(File image, String uploadedUrl) {
    final updatedImages = List<File>.from(state.localImages)..add(image);
    final updatedUrls = List<String>.from(state.imageUrls)..add(uploadedUrl);

    if (!isClosed) {
      emit(state.copyWith(
        localImages: updatedImages,
        imageUrls: updatedUrls,
      ));
    }
  }

  void clearImages() {
    emit(const ImagePickerState());
  }

  /// ✅ Upload all local images to Firebase and update imageUrls
  Future<void> uploadImagesToFirebase() async {
    emit(state.copyWith(loading: true));

    final uploadedUrls = <String>[];

    for (final image in state.localImages) {
      final url = await _storageRepository.uploadProductImage(
        filePath: image.path,
      );
      if (url.isNotEmpty) {
        uploadedUrls.add(url);
      } else {
        // Handle error if upload fails
        print('Failed to upload image: ${image.path}');
        emit(state.copyWith(loading: false));
        return;
      }
    }

    emit(state.copyWith(
      imageUrls: uploadedUrls,
      loading: false,
    ));
  }
}
