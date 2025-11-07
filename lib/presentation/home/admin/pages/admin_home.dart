import 'package:ecommerce/presentation/home/widgets/admin/admin_appbar.dart';
import 'package:ecommerce/presentation/home/widgets/admin/admin_menu.dart';
import 'package:ecommerce/presentation/home/widgets/admin/admin_product_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/service_locator.dart';
import 'package:ecommerce/domain/product/usecases/get_all_products.dart';
import 'package:ecommerce/data/product/repository/product.dart';
import 'package:ecommerce/domain/product/repository/product.dart';
import 'package:ecommerce/presentation/product/bloc/deleteProduct/product_delete_cubit.dart';
import 'package:ecommerce/common/bloc/product/product_display_cubit.dart';

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
              useCase: sl<GetAllProductsUseCase>(),
            )..displayProducts(),
          ),
        ],
        child: const Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child:  AdminAppBar(),
          ),
          body: Column(
            children: [
              AdminMenu(),
              Expanded(
                child: AdminProductSection(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
