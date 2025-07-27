import 'package:ecommerce/common/helper/cart/cart.dart';
import 'package:ecommerce/common/helper/navigator/app_navigator.dart';
import 'package:ecommerce/common/widgets/button/basic_app_button.dart';
import 'package:ecommerce/core/configs/theme/app_colors.dart';
import 'package:ecommerce/domain/order/entities/product_oredered.dart';
import 'package:ecommerce/presentation/cart/views/checkout.dart';
import 'package:flutter/material.dart';

class CheckOut extends StatelessWidget {
  final List<ProductOrderedEntity> products;
  const CheckOut({required this.products, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = theme.textTheme.bodyLarge?.color ?? (isDark ? Colors.white : Colors.black);
    final secondaryTextColor = theme.textTheme.bodySmall?.color ?? (isDark ? Colors.grey[300] : Colors.grey[700]);
    final subtotal = CartHelper.calculateCartSubtotal(products);
    final shipping = CartHelper.calculateShippingCost(products);
    final tax = 0.0;
    final total = subtotal + shipping + tax;
    return Container(
      padding: const EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height / 3.5,
      color: theme.scaffoldBackgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Subtotal', style: theme.textTheme.bodyLarge?.copyWith(color: secondaryTextColor)),
              Text(
                '\$${subtotal.toStringAsFixed(2)}',
                style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, color: textColor),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Shipping Cost', style: theme.textTheme.bodyLarge?.copyWith(color: secondaryTextColor)),
              Text(
                shipping == 0 ? 'Free' : '\$${shipping.toStringAsFixed(2)}',
                style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, color: textColor),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tax', style: theme.textTheme.bodyLarge?.copyWith(color: secondaryTextColor)),
              Text(
                '\$${tax.toStringAsFixed(2)}',
                style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, color: textColor),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total', style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.secondary)),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.secondary),
              ),
            ],
          ),
          BasicAppButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CheckOutPage(
                    products: products,
                  ),
                ),
              );
            },
            title: 'Checkout',
          ),
        ],
      ),
    );
  }
}
