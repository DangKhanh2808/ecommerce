import 'package:flutter/material.dart';

class ProductTitleInput extends StatelessWidget {
  final TextEditingController controller;

  const ProductTitleInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(labelText: "Title"),
      validator: (value) =>
          value == null || value.isEmpty ? 'Cannot be empty' : null,
    );
  }
}
