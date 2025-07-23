import 'dart:io';
import 'package:equatable/equatable.dart';

class ImagePickerState extends Equatable {
  final List<File> localImages;
  final List<String> imageUrls;
  final bool loading;

  const ImagePickerState({
    this.localImages = const [],
    this.imageUrls = const [],
    this.loading = false,
  });

  ImagePickerState copyWith({
    List<File>? localImages,
    List<String>? imageUrls,
    bool? loading,
  }) {
    return ImagePickerState(
      localImages: localImages ?? this.localImages,
      imageUrls: imageUrls ?? this.imageUrls,
      loading: loading ?? this.loading,
    );
  }

  @override
  List<Object> get props => [localImages, imageUrls, loading];
}
