// product_delete_state.dart

abstract class ProductDeleteState {}

class ProductDeleteInitial extends ProductDeleteState {}

class ProductDeleteLoading extends ProductDeleteState {}

class ProductDeleteSuccess extends ProductDeleteState {}

class ProductDeleteFailure extends ProductDeleteState {
  final String message;
  ProductDeleteFailure(this.message);
}
