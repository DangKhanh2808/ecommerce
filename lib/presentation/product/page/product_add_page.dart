import 'package:ecommerce/domain/category/repository/category.dart';
import 'package:ecommerce/domain/product/repository/product.dart';
import 'package:ecommerce/domain/storage/repository/storage.dart';
import 'package:ecommerce/presentation/product/bloc/image/image_cubit.dart';
import 'package:ecommerce/presentation/product/bloc/product_add_cubit.dart';
import 'package:ecommerce/presentation/product/bloc/product_add_state.dart';
import 'package:ecommerce/presentation/product/widget/product_add_form.dart';
import 'package:ecommerce/presentation/product/bloc/category/category_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class ProductAddPage extends StatelessWidget {
  const ProductAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    final productRepository = GetIt.I<ProductRepository>();
    final categoryRepository = GetIt.I<CategoryRepository>();
    final imagePickerRepository = GetIt.I<StorageRepository>();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ProductAddCubit(productRepository),
        ),
        BlocProvider(
          create: (_) => CategoryCubit(categoryRepository)..fetchCategories(),
        ),
        BlocProvider(
          create: (_) => ImagePickerCubit(imagePickerRepository),
        ),
      ],
      child: Scaffold(
          appBar: AppBar(title: const Text("Add Product")),
          body: BlocListener<ProductAddCubit, ProductAddState>(
            listener: (context, state) {
              if (state is ProductAddSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Product added successfully!")),
                );
                Navigator.pop(context, true);
              }
            },
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: ProductAddForm(),
            ),
          )),
    );
  }
}
