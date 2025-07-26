import 'package:ecommerce/domain/product/entity/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/product_size_selection_cubit.dart';

class SelectedSize extends StatelessWidget {
  final ProductEntity productEntity;
  const SelectedSize({required this.productEntity, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Size',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
          const SizedBox(height: 8),
          BlocBuilder<ProductSizeSelectionCubit, int>(
            builder: (context, selectedIndex) => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(
                productEntity.sizes.length,
                (index) => GestureDetector(
                  onTap: () {
                    context.read<ProductSizeSelectionCubit>().itemSelection(index);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: selectedIndex == index 
                          ? Theme.of(context).primaryColor 
                          : Colors.transparent,
                      border: Border.all(
                        color: selectedIndex == index 
                            ? Theme.of(context).primaryColor 
                            : Colors.grey.shade300,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      productEntity.sizes[index],
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: selectedIndex == index 
                            ? Colors.white 
                            : null,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
