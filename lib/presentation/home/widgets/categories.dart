import 'package:ecommerce/common/bloc/categories/categories_display_cubit.dart';
import 'package:ecommerce/common/bloc/categories/categories_display_state.dart';
import 'package:ecommerce/common/bloc/product/product_display_cubit.dart';
import 'package:ecommerce/common/bloc/product/product_display_state.dart';
import 'package:ecommerce/common/widgets/product/product_card.dart';
import 'package:ecommerce/domain/category/entity/category.dart';
import 'package:ecommerce/domain/product/usecases/get_new_in.dart';
import 'package:ecommerce/presentation/category_product/views/category_products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/service_locator.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CategoriesDisplayCubit()..displayCategories(),
        ),
        BlocProvider(
          create: (context) => ProductsDisplayCubit(useCase: sl<GetNewInUseCase>()),
        ),
      ],
      child: BlocBuilder<CategoriesDisplayCubit, CategoriesDisplayState>(
        builder: (context, state) {
          if (state is CategoriesLoaded) {
            return Column(
              children: [
                _header(),
                const SizedBox(
                  height: 16,
                ),
                _categoriesList(context, state.categories),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Categories',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          GestureDetector(
            onTap: () {
              // This navigation logic needs to be updated to navigate to a new page
              // For now, it's commented out to avoid breaking the existing code
              // AppNavigator.push(
              //   context,
              //   BlocProvider.value(
              //     value: context.read<ProductsDisplayCubit>(),
              //     child: const AllProductsPage(),
              //   ),
              // );
            },
            child: const Text(
              'See All',
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
            ),
          )
        ],
      ),
    );
  }

  Widget _categoriesList(BuildContext context, List<CategoryEntity> categories) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (contetx, index) {
            return Column(
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(
                            // This image URL generation needs to be updated
                            // For now, it's commented out to avoid breaking the existing code
                            // ImageDisplayHelper.generateCategoryImageURL(
                            //     categories[index].image),
                            'https://via.placeholder.com/60x60', // Placeholder
                          ))),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  categories[index].title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w400, fontSize: 14),
                )
              ],
            );
          },
          separatorBuilder: (context, index) => const SizedBox(width: 15),
          itemCount: categories.length),
    );
  }
}
