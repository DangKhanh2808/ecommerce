import 'package:ecommerce/common/helper/navigator/app_navigator.dart';
import 'package:ecommerce/core/configs/theme/app_colors.dart';
import 'package:ecommerce/domain/product/repository/product.dart';
import 'package:ecommerce/presentation/product/bloc/product_add_cubit.dart';
import 'package:ecommerce/presentation/product/page/product_add_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Nếu bạn dùng get_it để quản lý dependency:
import 'package:get_it/get_it.dart';

class AddProductTile extends StatelessWidget {
  const AddProductTile({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final productRepository = GetIt.I<ProductRepository>();

        AppNavigator.push(
          context,
          BlocProvider(
            create: (context) => ProductAddCubit(productRepository),
            child: const ProductAddPage(),
          ),
        );
      },
      child: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.secondBackground,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Add Product',
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
            ),
            Icon(Icons.arrow_forward_ios_rounded),
          ],
        ),
      ),
    );
  }
}
