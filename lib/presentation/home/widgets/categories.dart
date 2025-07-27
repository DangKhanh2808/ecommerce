import 'package:ecommerce/common/bloc/categories/categories_display_cubit.dart';
import 'package:ecommerce/common/bloc/categories/categories_display_state.dart';
import 'package:ecommerce/common/bloc/product/product_display_cubit.dart';
import 'package:ecommerce/common/bloc/product/product_display_state.dart';
import 'package:ecommerce/common/widgets/product/product_card.dart';
import 'package:ecommerce/domain/category/entity/category.dart';
import 'package:ecommerce/domain/product/usecases/get_new_in.dart';
import 'package:ecommerce/presentation/all_categories/views/all_categories.dart';
import 'package:ecommerce/presentation/category_product/views/category_products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/service_locator.dart';
import 'package:ecommerce/common/helper/app_images/image_display.dart';

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
            return _categoriesList(context, state.categories);
          }
          // Show placeholder instead of loading indicator
          return _categoriesPlaceholder(context);
        },
      ),
    );
  }

  Widget _categoriesPlaceholder(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 4, // Show 4 placeholder items
        itemBuilder: (context, index) {
          return Container(
            width: 80,
            margin: const EdgeInsets.only(right: 16),
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 12,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _categoriesList(BuildContext context, List<CategoryEntity> categories) {
    final theme = Theme.of(context);
    
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryProductsPage(
                    categoryEntity: categories[index],
                  ),
                ),
              );
            },
            child: SizedBox(
              width: 80,
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.dividerColor,
                        width: 1,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        ImageDisplayHelper.generateCategoryImageURL(categories[index].image),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: BoxDecoration(
                              color: theme.cardTheme.color,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.category,
                              color: theme.textTheme.bodyMedium?.color,
                              size: 30,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    categories[index].title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemCount: categories.length,
      ),
    );
  }
}
