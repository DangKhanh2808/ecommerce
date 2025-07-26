import 'package:ecommerce/common/bloc/product/product_display_cubit.dart';
import 'package:ecommerce/common/widgets/product/product_tile.dart';
import 'package:ecommerce/domain/product/repository/product.dart';
import 'package:ecommerce/domain/product/usecases/update_product.dart';
import 'package:ecommerce/presentation/product/bloc/deleteProduct/product_delete_cubit.dart';
import 'package:ecommerce/presentation/product/bloc/deleteProduct/product_delete_state.dart';
import 'package:ecommerce/presentation/product/bloc/updateProduct/update_product_cubit.dart';
import 'package:ecommerce/presentation/product/page/edit_product_page.dart';
import 'package:ecommerce/presentation/product/page/product_add_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/common/bloc/product/product_display_state.dart';
import 'package:get_it/get_it.dart';
import 'package:ecommerce/domain/category/repository/category.dart';
import 'package:ecommerce/domain/storage/repository/storage.dart';
import 'package:ecommerce/presentation/product/bloc/product_add_cubit.dart';
import 'package:ecommerce/presentation/product/bloc/category/category_cubit.dart';
import 'package:ecommerce/presentation/product/bloc/image/image_cubit.dart';
import 'package:ecommerce/service_locator.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductUpdateCubit(sl<UpdateProductUseCase>()),
      child: BlocBuilder<ProductsDisplayCubit, ProductsDisplayState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Product List'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    final productRepo = GetIt.I<ProductRepository>();
                    final categoryRepo = GetIt.I<CategoryRepository>();
                    final storageRepo = GetIt.I<StorageRepository>();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MultiBlocProvider(
                          providers: [
                            BlocProvider(
                              create: (_) => ProductAddCubit(productRepo),
                            ),
                            BlocProvider(
                              create: (_) => CategoryCubit(categoryRepo)
                                ..fetchCategories(),
                            ),
                            BlocProvider(
                              create: (_) => ImagePickerCubit(storageRepo),
                            ),
                          ],
                          child: const ProductAddPage(),
                        ),
                      ),
                    ).then((result) {
                      if (result == true) {
                        context.read<ProductsDisplayCubit>().displayProducts();
                      }
                    });
                  },
                )
              ],
            ),
            body: _buildBody(context, state),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, ProductsDisplayState state) {
    if (state is ProductsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is ProductsLoaded) {
      return ListView.builder(
        itemCount: state.products.length,
        itemBuilder: (context, index) {
          final product = state.products[index];
          return ProductTile(
            product: product,
            onTap: () => _editProduct(context, product),
            onDelete: () => _deleteProduct(context, product),
          );
        },
      );
    }

    if (state is LoadProductsFailure) {
      return Center(child: Text('Error: ${state.message}'));
    }

    return const Center(child: Text('No products found'));
  }

  void _editProduct(BuildContext context, dynamic product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => ProductUpdateCubit(sl<UpdateProductUseCase>()),
          child: EditProductPage(product: product),
        ),
      ),
    ).then((result) {
      if (result == true) {
        context.read<ProductsDisplayCubit>().displayProducts();
      }
    });
  }

  void _deleteProduct(BuildContext context, dynamic product) {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Are you sure you want to delete ${product.title}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Delete product logic here
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
