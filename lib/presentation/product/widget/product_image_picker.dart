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

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: pickAndUploadImages,
                  icon: const Icon(Icons.add_photo_alternate_rounded),
                  label: const Text('Chọn nhiều ảnh sản phẩm'),
                ),
                const SizedBox(width: 12),
                BlocBuilder<ImagePickerCubit, ImagePickerState>(
                  builder: (context, state) {
                    if (state.loading) {
                      return const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            BlocBuilder<ImagePickerCubit, ImagePickerState>(
              builder: (context, state) {
                if (state.localImages.isEmpty) {
                  return const Text("Chưa có ảnh nào.", style: TextStyle(color: Colors.grey));
                }
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: state.localImages.length,
                  itemBuilder: (context, index) {
                    final file = state.localImages[index];
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            file,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => imagePickerCubit.removeImage(file),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close, color: Colors.white, size: 18),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
