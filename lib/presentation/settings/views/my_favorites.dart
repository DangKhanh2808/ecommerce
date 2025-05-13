import 'package:ecommerce/common/bloc/product/product_display_cubit.dart';
import 'package:ecommerce/common/bloc/product/product_display_state.dart';
import 'package:ecommerce/common/widgets/product/product_card.dart';
import 'package:ecommerce/domain/product/entity/product.dart';
import 'package:ecommerce/domain/product/usecases/get_favorites_products.dart';
import 'package:ecommerce/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyFavoritesPage extends StatelessWidget {
  const MyFavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
      ),
      body: BlocProvider(
        create: (context) =>
            ProductsDisplayCubit(useCase: sl<GetFavoritesProductsUseCase>())
              ..displayProducts(),
        child: BlocBuilder<ProductsDisplayCubit, ProductsDisplayState>(
          builder: (context, state) {
            if (state is ProductsLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is ProductsLoaded) {
              return _products(state.products);
            }

            if (state is LoadProductsFailure) {
              return Center(
                child: Text(
                  'Please try again later',
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget _products(List<ProductEntity> products) {
    return Expanded(
      child: GridView.builder(
        itemCount: products.length,
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.6),
        itemBuilder: (BuildContext context, int index) {
          return ProductCard(productEntity: products[index]);
        },
      ),
    );
  }
}
