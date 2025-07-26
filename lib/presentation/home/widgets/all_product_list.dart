import 'package:ecommerce/common/widgets/product/product_card.dart';
import 'package:ecommerce/common/bloc/product/product_display_cubit.dart';
import 'package:ecommerce/common/bloc/product/product_display_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/service_locator.dart';
import 'package:ecommerce/domain/product/usecases/get_products_by_title.dart';

class AllProductsPage extends StatefulWidget {
  const AllProductsPage({super.key});

  @override
  State<AllProductsPage> createState() => _AllProductsPageState();
}

class _AllProductsPageState extends State<AllProductsPage> {
  String _searchQuery = '';
  double _selectedMinPrice = 0;
  double _selectedMaxPrice = 1000;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductsDisplayCubit(useCase: sl<GetProductsByTitleUseCase>())..displayProducts(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('All Products'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(100),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Price:'),
                    DropdownButton<double>(
                      value: _selectedMinPrice,
                      items: List.generate(10, (i) => i * 100)
                          .map((price) => DropdownMenuItem(
                                value: price.toDouble(),
                                child: Text('$price'),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedMinPrice = value ?? 0;
                        });
                      },
                    ),
                    const Text('to'),
                    DropdownButton<double>(
                      value: _selectedMaxPrice,
                      items: List.generate(10, (i) => (i + 1) * 100)
                          .map((price) => DropdownMenuItem(
                                value: price.toDouble(),
                                child: Text('$price'),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedMaxPrice = value ?? 1000;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: BlocBuilder<ProductsDisplayCubit, ProductsDisplayState>(
          builder: (context, state) {
            if (state is ProductsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProductsLoaded) {
              final products = state.products.where((product) {
                final matchesSearchQuery = product.title
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase());
                final matchesPriceRange = product.price >= _selectedMinPrice &&
                    product.price <= _selectedMaxPrice;
                return matchesSearchQuery && matchesPriceRange;
              }).toList();

              if (products.isEmpty) {
                return const Center(child: Text('No products found.'));
              }

              return GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 3 / 4,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    height: 280,
                    child: ProductCard(productEntity: products[index]),
                  );
                },
              );
            } else if (state is LoadProductsFailure) {
              return Center(child: Text('Error: ${state.message}'));
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
