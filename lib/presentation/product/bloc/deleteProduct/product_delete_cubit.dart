import 'package:ecommerce/domain/product/repository/product.dart';
import 'package:ecommerce/presentation/product/bloc/deleteProduct/product_delete_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDeleteCubit extends Cubit<ProductDeleteState> {
  final ProductRepository repository;

  ProductDeleteCubit(this.repository) : super(ProductDeleteInitial());

  Future<void> deleteProduct(String productId) async {
    emit(ProductDeleteLoading());

    try {
      await repository.deleteProduct(productId);
      emit(ProductDeleteSuccess());
    } catch (e) {
      emit(ProductDeleteFailure(e.toString()));
    }
  }

  void reset() {
    emit(ProductDeleteInitial());
  }
}
