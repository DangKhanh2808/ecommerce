import 'package:flutter/material.dart';

class ProductPriceField extends StatelessWidget {
  final TextEditingController controller;

  const ProductPriceField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(labelText: 'Price'),
      keyboardType: TextInputType.number,
      validator: (value) =>
          value == null || value.trim().isEmpty ? 'Do not leave blank' : null,
    );
  }
}
