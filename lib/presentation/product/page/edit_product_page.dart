import 'package:ecommerce/domain/product/entity/product.dart';
import 'package:ecommerce/presentation/product/bloc/updateProduct/update_product_cubit.dart';
import 'package:ecommerce/presentation/product/bloc/updateProduct/update_product_state.dart';
import 'package:ecommerce/presentation/product/widget/product_price_field.dart';
import 'package:ecommerce/presentation/product/widget/product_title_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProductPage extends StatefulWidget {
  final ProductEntity product;

  const EditProductPage({super.key, required this.product});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.product.title);
    _priceController =
        TextEditingController(text: widget.product.price.toString());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Edit Product')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocListener<ProductUpdateCubit, ProductUpdateState>(
            listener: (context, state) {
              if (state is ProductUpdateSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Update successful')),
                );
                Navigator.pop(context, true);
              } else if (state is ProductUpdateFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${state.message}')),
                );
              }
            },
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  ProductTitleField(controller: _titleController),
                  const SizedBox(height: 16),
                  ProductPriceField(controller: _priceController),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final updatedProduct = ProductEntity(
                          docId: widget.product.docId,
                          productId: widget.product.productId,
                          title: _titleController.text,
                          price: num.tryParse(_priceController.text) ?? 0,
                          createdDate: widget.product.createdDate,
                          categoryId: widget.product.categoryId,
                          discountedPrice: widget.product.discountedPrice,
                          gender: widget.product.gender,
                          images: widget.product.images,
                          sizes: widget.product.sizes,
                          salesNumber: widget.product.salesNumber,
                          colors: widget.product.colors,
                        );

                        context
                            .read<ProductUpdateCubit>()
                            .updateProduct(updatedProduct);
                      }
                    },
                    child: const Text('Update Product'),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
