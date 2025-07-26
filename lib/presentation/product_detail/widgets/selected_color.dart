import 'package:ecommerce/domain/product/entity/product.dart';
import 'package:ecommerce/domain/product/entity/color.dart';
import 'package:ecommerce/presentation/product_detail/bloc/product_color_selection_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/helper/product/default_colors.dart';

class SelectedColor extends StatelessWidget {
  final ProductEntity productEntity;
  const SelectedColor({required this.productEntity, super.key});

  @override
  Widget build(BuildContext context) {
    // Always use default colors to ensure users see all colors
    final colorsToShow = DefaultColors.colorEntities;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Color',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
          const SizedBox(height: 8),
          BlocBuilder<ProductColorSelectionCubit, int>(
            builder: (context, selectedIndex) => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(
                colorsToShow.length,
                (index) => GestureDetector(
                  onTap: () {
                    context.read<ProductColorSelectionCubit>().itemSelection(index);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 16,
                          width: 16,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(
                                colorsToShow[index].rgb[0],
                                colorsToShow[index].rgb[1],
                                colorsToShow[index].rgb[2],
                                1),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          colorsToShow[index].title,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: selectedIndex == index 
                                ? Colors.white 
                                : null,
                          ),
                        ),
                      ],
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
