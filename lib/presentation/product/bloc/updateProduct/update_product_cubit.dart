import 'package:ecommerce/domain/product/entity/product.dart';
import 'package:ecommerce/domain/product/usecases/update_product.dart';
import 'package:ecommerce/presentation/product/bloc/updateProduct/update_product_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductUpdateCubit extends Cubit<ProductUpdateState> {
  final UpdateProductUseCase updateProductUseCase;

  ProductUpdateCubit(this.updateProductUseCase) : super(ProductUpdateInitial());

  Future<void> updateProduct(ProductEntity product) async {
    emit(ProductUpdateLoading());
    final result = await updateProductUseCase.call(params: product);
    result.fold(
      (error) => emit(ProductUpdateFailure(error.toString())),
      (_) => emit(ProductUpdateSuccess()),
    );
  }

  void reset() => emit(ProductUpdateInitial());
}
