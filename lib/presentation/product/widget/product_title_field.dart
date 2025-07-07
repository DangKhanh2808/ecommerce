import 'package:flutter/material.dart';

class ProductTitleField extends StatelessWidget {
  final TextEditingController controller;

  const ProductTitleField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(labelText: 'Title'),
      validator: (value) =>
          value == null || value.trim().isEmpty ? 'Do not leave blank' : null,
    );
  }
}
