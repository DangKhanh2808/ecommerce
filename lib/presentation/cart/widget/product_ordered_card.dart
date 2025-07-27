import 'package:ecommerce/common/helper/app_images/image_display.dart';
import 'package:ecommerce/domain/order/entities/product_oredered.dart';
import 'package:ecommerce/presentation/cart/bloc/cart_products_display_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/configs/theme/app_colors.dart';

class ProductOrderedCard extends StatelessWidget {
  final ProductOrderedEntity productOrderedEntity;
  const ProductOrderedCard({
    required this.productOrderedEntity,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = theme.textTheme.bodyLarge?.color ?? (isDark ? Colors.white : Colors.black);
    final secondaryTextColor = theme.textTheme.bodySmall?.color ?? (isDark ? Colors.grey[300] : Colors.grey[700]);
    return Container(
      height: 100,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black12 : Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    width: 90,
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(
                          ImageDisplayHelper.generateProductImageURL(productOrderedEntity.productImage),
                        ),
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productOrderedEntity.productTitle,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      Row(
                        children: [
                          Text('Size: ', style: theme.textTheme.bodySmall?.copyWith(color: secondaryTextColor)),
                          Text(productOrderedEntity.productSize, style: theme.textTheme.bodySmall?.copyWith(color: textColor)),
                          const SizedBox(width: 10),
                          Text('Color: ', style: theme.textTheme.bodySmall?.copyWith(color: secondaryTextColor)),
                          Text(productOrderedEntity.productColor, style: theme.textTheme.bodySmall?.copyWith(color: textColor)),
                          const SizedBox(width: 10),
                          Text('Qty: ', style: theme.textTheme.bodySmall?.copyWith(color: secondaryTextColor)),
                          Text('${productOrderedEntity.productQuantity}', style: theme.textTheme.bodySmall?.copyWith(color: textColor)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${productOrderedEntity.totalPrice}',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.secondary),
                ),
                GestureDetector(
                  onTap: () {
                    context.read<CartProductsDisplayCubit>().removeProduct(productOrderedEntity);
                  },
                  child: Container(
                    height: 23,
                    width: 23,
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(isDark ? 0.8 : 0.9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.remove,
                      size: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
