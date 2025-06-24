import 'package:ecommerce/presentation/product/bloc/category/category_cubit.dart';
import 'package:ecommerce/presentation/product/bloc/category/category_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/domain/category/entity/category.dart';

class CategoryDropdownTile extends StatelessWidget {
  final String? selectedCategoryId;
  final ValueChanged<String?> onChanged;

  const CategoryDropdownTile({
    super.key,
    required this.selectedCategoryId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CategoryLoaded) {
          return DropdownButtonFormField<String>(
            value: selectedCategoryId,
            decoration: const InputDecoration(
              labelText: 'Select Category',
              border: OutlineInputBorder(),
            ),
            items: state.categories.map((CategoryEntity category) {
              return DropdownMenuItem<String>(
                value: category.categoryId,
                child: Text(category.title),
              );
            }).toList(),
            onChanged: onChanged,
            validator: (value) => value == null || value.isEmpty
                ? 'Please select a category'
                : null,
          );
        } else if (state is CategoryError) {
          return Text('Error: ${state.message}');
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
