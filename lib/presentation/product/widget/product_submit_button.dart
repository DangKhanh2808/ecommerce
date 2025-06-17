import 'package:ecommerce/presentation/product/bloc/product_add_cubit.dart';
import 'package:ecommerce/presentation/product/bloc/product_add_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/domain/product/entity/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductSubmitButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController priceController;

  const ProductSubmitButton({
    super.key,
    required this.formKey,
    required this.titleController,
    required this.priceController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductAddCubit, ProductAddState>(
      builder: (context, state) {
        if (state is ProductAddLoading) {
          return const CircularProgressIndicator();
        }

        return ElevatedButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              final product = ProductEntity(
                productId: '',
                title: titleController.text,
                price: num.tryParse(priceController.text) ?? 0,
                createdDate: Timestamp.now(),
                categoryId: 'default',
                discountedPrice: 0,
                gender: 0,
                images: [],
                sizes: [],
                salesNumber: 0,
                colors: [],
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
