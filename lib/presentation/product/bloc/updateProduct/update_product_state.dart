abstract class ProductUpdateState {}

class ProductUpdateInitial extends ProductUpdateState {}

class ProductUpdateLoading extends ProductUpdateState {}

class ProductUpdateSuccess extends ProductUpdateState {}

class ProductUpdateFailure extends ProductUpdateState {
  final String message;

  ProductUpdateFailure(this.message);
}
