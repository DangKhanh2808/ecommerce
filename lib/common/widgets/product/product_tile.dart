// lib/presentation/product/widget/product_tile.dart

import 'package:flutter/material.dart';
import 'package:ecommerce/domain/product/entity/product.dart';

class ProductTile extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const ProductTile({
    super.key,
    required this.product,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        leading: const Icon(Icons.shopping_bag),
        title: Text(product.title),
        subtitle: Text('Price: ${product.price}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
