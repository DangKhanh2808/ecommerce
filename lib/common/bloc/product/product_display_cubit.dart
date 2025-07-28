import 'package:ecommerce/common/bloc/product/product_display_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/domain/product/entity/product.dart';
import 'package:ecommerce/data/product/models/product.dart';

class ProductsDisplayCubit extends Cubit<ProductsDisplayState> {
  final dynamic useCase;
  ProductsDisplayCubit({required this.useCase}) : super(ProductsInitialState());

  void displayProducts({dynamic params}) async {
    emit(ProductsLoading());
    var returnedData = await useCase.call(params: params);
    returnedData.fold((error) {
      emit(LoadProductsFailure(error));
    }, (data) {
      final products = List<ProductEntity>.from(
        data.map((doc) {
          if (doc is ProductEntity) return doc;
          if (doc is Map<String, dynamic>) {
            return ProductModel.fromMap(doc, doc['docId'] ?? '').toEntity();
          }
          if (doc.data != null && doc.id != null) {
            final map = doc.data() as Map<String, dynamic>;
            return ProductModel.fromMap(map, doc.id).toEntity();
          }
          throw Exception('Unknown product data type');
        }),
      );
      emit(ProductsLoaded(products: products));
    });
  }

  void displayInitial() {
    emit(ProductsInitialState());
  }
}
