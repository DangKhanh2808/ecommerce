import 'package:ecommerce/domain/product/entity/color.dart';
import 'package:ecommerce/presentation/product/bloc/image/image_cubit.dart';
import 'package:ecommerce/presentation/product/bloc/product_add_cubit.dart';
import 'package:ecommerce/presentation/product/bloc/product_add_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/domain/product/entity/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../common/helper/product/default_colors.dart';

class ProductSubmitButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController priceController;
  final String? selectedCategoryId;
  final ImagePickerCubit imagePickerCubit;

  const ProductSubmitButton({
    super.key,
    required this.formKey,
    required this.titleController,
    required this.priceController,
    required this.selectedCategoryId,
    required this.imagePickerCubit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductAddCubit, ProductAddState>(
      builder: (context, state) {
        if (state is ProductAddLoading) {
          return const CircularProgressIndicator();
        }

        return ElevatedButton(
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              await imagePickerCubit.uploadImagesToFirebase();

              final imageUrls = imagePickerCubit.state.imageUrls;

              final product = ProductEntity(
                productId: '',
                title: titleController.text,
                price: num.tryParse(priceController.text) ?? 0,
                createdDate: Timestamp.now(),
                categoryId: selectedCategoryId ?? '',
                discountedPrice: 0,
                gender: 0,
                images: imageUrls,
                sizes: ['35', '37', '40', '42'],
                salesNumber: 0,
                colors: DefaultColors.colorEntities,
              );

              context.read<ProductAddCubit>().createProduct(product);
            }
          },
          child: const Text("Add Product"),
        );
      },
    );
  }
}
