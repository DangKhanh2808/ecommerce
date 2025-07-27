import 'package:ecommerce/common/widgets/appbar/app_bar.dart';
import 'package:ecommerce/domain/order/entities/product_oredered.dart';
import 'package:ecommerce/presentation/settings/widgets/product_ordered_card.dart';
import 'package:flutter/material.dart';

import '../../../core/configs/theme/theme_helper.dart';

class OrderItemsPage extends StatelessWidget {
  final List<ProductOrderedEntity> products;

  const OrderItemsPage({
    super.key,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        title: Text('Order Items'),
      ),
      body: _products(products),
    );
  }

  Widget _products(List<ProductOrderedEntity> products) {
    return Builder(
      builder: (context) => Container(
        color: ThemeHelper.getBackgroundColor(context),
        child: ListView.separated(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        return OrderItemsCard(
          productOrderedEntity: products[index],
        );
      },
      separatorBuilder: (context, index) => const SizedBox(
            height: 12,
          ),
          itemCount: products.length,
        ),
      ),
    );
  }
}
