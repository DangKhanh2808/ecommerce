import 'package:ecommerce/domain/product/repository/product.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'product_add_state.dart';
import 'package:ecommerce/domain/product/entity/product.dart';

class ProductAddCubit extends Cubit<ProductAddState> {
  final ProductRepository repository;

  ProductAddCubit(this.repository) : super(ProductAddInitial());

  Future<void> createProduct(ProductEntity product) async {
    emit(ProductAddLoading());
    try {
      await repository.createProduct(product);
      emit(ProductAddSuccess());
    } catch (e) {
      emit(ProductAddFailure(e.toString()));
    }
  }
}
