import 'package:ecommerce/presentation/product/widget/category_dropdown_tile.dart';
import 'package:flutter/material.dart';
import 'product_price_input.dart';
import 'product_title_input.dart';
import 'product_submit_button.dart';

class ProductAddForm extends StatefulWidget {
  const ProductAddForm({super.key});

  @override
  State<ProductAddForm> createState() => _ProductAddFormState();
}

class _ProductAddFormState extends State<ProductAddForm> {
  String? selectedCategoryId;
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          ProductTitleInput(controller: _titleController),
          const SizedBox(height: 12),
          ProductPriceInput(controller: _priceController),
          const SizedBox(height: 12),
          CategoryDropdownTile(
            selectedCategoryId: selectedCategoryId,
            onChanged: (value) {
              setState(() {
                selectedCategoryId = value;
              });
            },
          ),
          const SizedBox(height: 20),
          ProductSubmitButton(
            formKey: _formKey,
            titleController: _titleController,
            priceController: _priceController,
            selectedCategoryId: selectedCategoryId,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
