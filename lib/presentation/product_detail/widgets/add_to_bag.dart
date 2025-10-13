import 'package:ecommerce/common/bloc/button/button_state.dart';
import 'package:ecommerce/common/bloc/button/button_state_cubit.dart';
// Removed navigation on add-to-cart to stay on product page

import 'package:ecommerce/common/helper/product/product_price.dart';
import 'package:ecommerce/common/widgets/button/basic_reative_button.dart';
import 'package:ecommerce/data/order/model/add_to_cart_req.dart';
import 'package:ecommerce/domain/order/usecases/add_to_cart.dart';
import 'package:ecommerce/domain/product/entity/product.dart';
// import 'package:ecommerce/presentation/home/user/pages/home.dart';
import 'package:ecommerce/presentation/product_detail/bloc/product_color_selection_cubit.dart';
import 'package:ecommerce/presentation/product_detail/bloc/product_quantity_cubit.dart';
import 'package:ecommerce/presentation/product_detail/bloc/product_size_selection_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/service_locator.dart';

class AddToBag extends StatelessWidget {
  final ProductEntity productEntity;
  const AddToBag({required this.productEntity, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ButtonStateCubit, ButtonState>(
      listener: (context, state) {
        if (state is ButtonSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Added to cart'),
              behavior: SnackBarBehavior.floating,
              duration: Duration(milliseconds: 1200),
            ),
          );
        }
        if (state is ButtonFailureState) {
          var snackbar = SnackBar(
            content: Text(state.errorMessage),
            behavior: SnackBarBehavior.floating,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: BasicReactiveButton(
          onPressed: () {
            context.read<ButtonStateCubit>().execute(
                usecase: sl<AddToCartUseCase>(),
                params: AddToCartReq(
                  productId: productEntity.productId,
                  productTitle: productEntity.title,
                  productQuantity: context.read<ProductQuantityCubit>().state,
                  productColor: productEntity
                      .colors[context
                          .read<ProductColorSelectionCubit>()
                          .selectdIndex]
                      .title,
                  productSize: productEntity.sizes[
                      context.read<ProductSizeSelectionCubit>().selectedIndex],
                  productPrice: productEntity.price.toDouble(),
                  totalPrice:
                      ProductPriceHelper.provideCurrentPrice(productEntity) *
                          context.read<ProductQuantityCubit>().state,
                  productImage: productEntity.images[0],
                  createdDate: DateTime.now().toString(),
                ));
          },
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BlocBuilder<ProductQuantityCubit, int>(
                builder: (context, state) {
                  var price =
                      ProductPriceHelper.provideCurrentPrice(productEntity) *
                          state;
                  return Text(
                    "\$${price.toString()}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 14),
                  );
                },
              ),
              const Text(
                'Add to Bag',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddedToCartOverlay extends StatefulWidget {
  const _AddedToCartOverlay();

  @override
  State<_AddedToCartOverlay> createState() => _AddedToCartOverlayState();
}

class _AddedToCartOverlayState extends State<_AddedToCartOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _scale = Tween<double>(begin: 0.8, end: 1.1)
        .chain(CurveTween(curve: Curves.easeOutBack))
        .animate(_controller);
    _opacity = Tween<double>(begin: 0.0, end: 1.0)
        .chain(CurveTween(curve: Curves.easeIn))
        .animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return Center(
                  child: Opacity(
                    opacity: _opacity.value * (1 - (_controller.value * 0.6)),
                    child: ScaleTransition(
                      scale: _scale,
                      child: Material(
                        type: MaterialType.transparency,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.85,
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.70),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: Colors.white12,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: const Icon(Icons.check,
                                      color: Colors.white),
                                ),
                                const SizedBox(width: 12),
                                const Flexible(
                                  child: Text(
                                    'Added to cart',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
