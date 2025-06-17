import 'package:flutter/material.dart';

class ProductPriceInput extends StatelessWidget {
  final TextEditingController controller;

  const ProductPriceInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(labelText: "Price"),
      validator: (value) =>
          value == null || value.isEmpty ? 'Cannot be empty' : null,
    );
  }
}
