import 'package:ecommerce/common/widgets/appbar/app_bar.dart';
import 'package:ecommerce/domain/order/entities/product_oredered.dart';
import 'package:ecommerce/presentation/cart/bloc/cart_products_display_cubit.dart';
import 'package:ecommerce/presentation/cart/bloc/cart_products_display_state.dart';
import 'package:ecommerce/presentation/cart/widget/product_ordered_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        title: Text('Cart'),
      ),
      body: BlocProvider(
          create: (context) => CartProductsDisplayCubit()..displayCartProduct(),
          child:
              BlocBuilder<CartProductsDisplayCubit, CartProductsDisplayState>(
            builder: (context, state) {
              if (state is CartProductsLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is CartProductsLoaded) {
                return _products(state.products);
              }

              if (state is LoadCartProductsFailure) {
                return Center(
                  child: Text(state.errorMessage),
                );
              }

              return Container();
            },
          )),
    );
  }

  Widget _products(List<ProductOrderedEntity> products) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        return ProductOrderedCard(
          productOrderedEntity: products[index],
        );
      },
      separatorBuilder: (context, index) => const SizedBox(
        height: 10,
      ),
      itemCount: products.length,
    );
  }
}
