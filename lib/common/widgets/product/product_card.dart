import 'package:ecommerce/common/helper/app_images/image_display.dart';
import 'package:ecommerce/common/helper/navigator/app_navigator.dart';
import 'package:ecommerce/domain/product/entity/product.dart';
import 'package:ecommerce/presentation/product_detail/pages/product_detail.dart';
import 'package:flutter/material.dart';

import '../../../core/configs/theme/app_colors.dart';

class ProductCard extends StatelessWidget {
  final ProductEntity productEntity;
  const ProductCard({required this.productEntity, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppNavigator.push(
            context,
            ProductDetailPage(
              productEntity: productEntity,
            ));
      },
      child: Container(
        width: 160,
        decoration: BoxDecoration(
            color: AppColors.primary, 
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            ImageDisplayHelper.generateProductImageURL(
                                productEntity.images[0]))),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8))),
              ),
            ),
            // Content section
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Product title
                    Flexible(
                      child: Text(
                        productEntity.title,
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Price section
                    Row(
                      children: [
                        // Current price
                        Flexible(
                          child: Text(
                            productEntity.discountedPrice == 0
                                ? "${productEntity.price}\$"
                                : "${productEntity.discountedPrice}\$",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Original price (if discounted)
                        if (productEntity.discountedPrice != 0) ...[
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              "${productEntity.price}\$",
                              style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w300,
                                  decoration: TextDecoration.lineThrough),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
