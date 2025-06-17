abstract class ProductAddState {}

class ProductAddInitial extends ProductAddState {}

class ProductAddLoading extends ProductAddState {}

class ProductAddSuccess extends ProductAddState {}

class ProductAddFailure extends ProductAddState {
  final String message;
  ProductAddFailure(this.message);
}
