import 'package:ecommerce/common/bloc/product/product_display_cubit.dart';
import 'package:ecommerce/common/widgets/product/product_tile.dart';
import 'package:ecommerce/domain/product/usecases/update_product.dart';

import 'package:ecommerce/presentation/product/bloc/deleteProduct/product_delete_cubit.dart';
import 'package:ecommerce/presentation/product/bloc/deleteProduct/product_delete_state.dart';
import 'package:ecommerce/presentation/product/bloc/updateProduct/update_product_cubit.dart';
import 'package:ecommerce/presentation/product/page/edit_product_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/common/bloc/product/product_display_state.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductUpdateCubit(UpdateProductUseCase()),
      child: BlocBuilder<ProductsDisplayCubit, ProductsDisplayState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text('Product List')),
            body: MultiBlocListener(
              listeners: [
                BlocListener<ProductDeleteCubit, ProductDeleteState>(
                  listener: (context, state) {
                    if (state is ProductDeleteSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Delete successful')),
                      );
                      context.read<ProductsDisplayCubit>().displayProducts();
                    } else if (state is ProductDeleteFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Delete error: ${state.message}')),
                      );
                    }
                  },
                ),
              ],
              child: BlocBuilder<ProductsDisplayCubit, ProductsDisplayState>(
                builder: (context, state) {
                  if (state is ProductsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ProductsLoaded) {
                    final products = state.products;
                    if (products.isEmpty) {
                      return const Center(child: Text('No products found'));
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];

                        return ProductTile(
                          product: product,
                          onDelete: () {
                            context
                                .read<ProductDeleteCubit>()
                                .deleteProduct(product.productId);
                          },
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (_) => ProductUpdateCubit(
                                      UpdateProductUseCase()),
                                  child: EditProductPage(product: product),
                                ),
                              ),
                            ).then((result) {
                              if (result == true) {
                                context
                                    .read<ProductsDisplayCubit>()
                                    .displayProducts(); // làm mới danh sách nếu update xong
                              }
                            });
                          },
                        );
                      },
                    );
                  } else if (state is LoadProductsFailure) {
                    return const Center(child: Text('Error loading products'));
                  }
                  return const SizedBox();
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
