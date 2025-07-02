import 'package:ecommerce/common/bloc/product/product_display_cubit.dart';
import 'package:ecommerce/data/product/repository/product.dart';
import 'package:ecommerce/domain/product/repository/product.dart';
import 'package:ecommerce/domain/product/usecases/get_new_in.dart';
import 'package:ecommerce/presentation/home/widgets/categories.dart';
import 'package:ecommerce/presentation/home/widgets/header.dart';
import 'package:ecommerce/presentation/home/widgets/search_field.dart';
import 'package:ecommerce/presentation/product/bloc/deleteProduct/product_delete_cubit.dart';
import 'package:ecommerce/presentation/product/page/product_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<ProductRepository>(
      create: (_) => ProductRepositoryImpl(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                ProductDeleteCubit(context.read<ProductRepository>()),
          ),
          BlocProvider(
            create: (context) => ProductsDisplayCubit(
              useCase: GetNewInUseCase(),
            )..displayProducts(),
          ),
        ],
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                const Header(),
                const SizedBox(height: 24),
                const SearchField(),
                const SizedBox(height: 24),
                const Categories(),
                const SizedBox(
                  height: 600,
                  child: ProductListPage(), // ✅ Không cần Provider nữa
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
