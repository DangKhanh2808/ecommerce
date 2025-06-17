import 'package:ecommerce/presentation/product/bloc/product_add_cubit.dart';
import 'package:ecommerce/presentation/product/widget/product_add_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/presentation/product/bloc/product_add_state.dart';

class ProductAddPage extends StatelessWidget {
  const ProductAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Product")),
      body: BlocListener<ProductAddCubit, ProductAddState>(
        listener: (context, state) {
          if (state is ProductAddSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Product added successfully!")),
            );
          } else if (state is ProductAddFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text("Failed to add product: ${state.message}")),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ProductAddForm(),
        ),
      ),
    );
  }
}
