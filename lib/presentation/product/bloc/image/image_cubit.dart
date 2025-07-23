import 'dart:io';
import 'package:ecommerce/domain/storage/repository/storage.dart';
import 'package:ecommerce/presentation/product/bloc/image/image_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImagePickerCubit extends Cubit<ImagePickerState> {
  ImagePickerCubit(StorageRepository imagePickerRepository)
      : super(const ImagePickerState());

  void setLoading(bool value) => emit(state.copyWith(loading: value));

  void addImage(File image, String uploadedUrl) {
    final updatedImages = List<File>.from(state.localImages)..add(image);
    final updatedUrls = List<String>.from(state.imageUrls)..add(uploadedUrl);

    emit(state.copyWith(
      localImages: updatedImages,
      imageUrls: updatedUrls,
    ));
  }

  void clearImages() {
    emit(const ImagePickerState());
  }
}
