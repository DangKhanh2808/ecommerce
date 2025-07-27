import 'package:ecommerce/common/helper/app_images/image_display.dart';
import 'package:ecommerce/domain/order/entities/product_oredered.dart';
import 'package:flutter/material.dart';

import '../../../core/configs/theme/app_colors.dart';
import '../../../core/configs/theme/theme_helper.dart';

class OrderItemsCard extends StatelessWidget {
  final ProductOrderedEntity productOrderedEntity;
  const OrderItemsCard({
    required this.productOrderedEntity,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 120),
      padding: const EdgeInsets.all(16),
      decoration: ThemeHelper.getCardDecoration(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: ThemeHelper.getShadowColor(context),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  ImageDisplayHelper.generateProductImageURL(
                    productOrderedEntity.productImage,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Title
                Text(
                  productOrderedEntity.productTitle,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: ThemeHelper.getTextPrimaryColor(context),
                  ),
                ),
                const SizedBox(height: 8),
                // Size and Color Tags
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Flexible(
                        child: Text(
                          'Size: ${productOrderedEntity.productSize}',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                            fontSize: 11,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Flexible(
                        child: Text(
                          'Color: ${productOrderedEntity.productColor}',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                            fontSize: 11,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Quantity and Price Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Qty: ${productOrderedEntity.productQuantity}',
                      style: TextStyle(
                        color: ThemeHelper.getTextSecondaryColor(context),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${productOrderedEntity.totalPrice}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: ThemeHelper.getTextPrimaryColor(context),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          'Price: \$${productOrderedEntity.productPrice}',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 11,
                            color: ThemeHelper.getTextSecondaryColor(context),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
