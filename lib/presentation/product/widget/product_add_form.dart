import 'package:ecommerce/presentation/product/widget/category_dropdown_tile.dart';
import 'package:ecommerce/presentation/product/widget/product_image_picker.dart';
import 'package:flutter/material.dart';
import 'product_price_input.dart';
import 'product_title_input.dart';
import 'product_submit_button.dart';
import 'package:ecommerce/presentation/product/bloc/image/image_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductAddForm extends StatefulWidget {
  const ProductAddForm({super.key});

  @override
  State<ProductAddForm> createState() => _ProductAddFormState();
}

class _ProductAddFormState extends State<ProductAddForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  String? selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hình ảnh sản phẩm
            const ProductImagePicker(),
            const SizedBox(height: 12),

            // Tên sản phẩm
            ProductTitleInput(controller: _titleController),
            const SizedBox(height: 12),

            // Giá sản phẩm
            ProductPriceInput(controller: _priceController),
            const SizedBox(height: 12),

            // Danh mục
            CategoryDropdownTile(
              selectedCategoryId: selectedCategoryId,
              onChanged: (value) {
                setState(() {
                  selectedCategoryId = value;
                });
              },
            ),

            const SizedBox(height: 20),

            // Nút Submit
            ProductSubmitButton(
              formKey: _formKey,
              titleController: _titleController,
              priceController: _priceController,
              selectedCategoryId: selectedCategoryId,
              imagePickerCubit: context.read<ImagePickerCubit>(),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
