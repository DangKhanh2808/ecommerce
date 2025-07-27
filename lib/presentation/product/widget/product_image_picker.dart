import 'dart:io';
import 'package:ecommerce/domain/storage/usecase/upload_product_image.dart';
import 'package:ecommerce/presentation/product/bloc/image/image_cubit.dart';
import 'package:ecommerce/presentation/product/bloc/image/image_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

class ProductImagePicker extends StatelessWidget {
  const ProductImagePicker({super.key});

  @override
  Widget build(BuildContext context) {
    final imagePickerCubit = context.read<ImagePickerCubit>();
    final uploadUseCase = GetIt.I<UploadProductImageUseCase>();

    Future<void> pickAndUploadImages() async {
      final picker = ImagePicker();
      final images = await picker.pickMultiImage();
      if (images.isEmpty) return;

      imagePickerCubit.setLoading(true);

      for (var image in images) {
        final file = File(image.path);
        final url = await uploadUseCase(params: file.path);
        if (url.isNotEmpty) {
          imagePickerCubit.addImage(file, url);
        } else {
          debugPrint("Upload error: Failed to upload image");
        }
      }

      imagePickerCubit.setLoading(false);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton.icon(
          onPressed: pickAndUploadImages,
          icon: const Icon(Icons.upload),
          label: const Text('Select and upload image'),
        ),
        const SizedBox(height: 10),
        BlocBuilder<ImagePickerCubit, ImagePickerState>(
          builder: (context, state) {
            if (state.loading) {
              return const CircularProgressIndicator();
            }

            if (state.localImages.isEmpty) {
              return const Text("No images yet.");
            }

            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: state.localImages
                  .map((file) => Image.file(file, width: 80, height: 80))
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}
