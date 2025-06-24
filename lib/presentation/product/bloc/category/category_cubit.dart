import 'package:ecommerce/domain/category/repository/category.dart';
import 'package:ecommerce/presentation/product/bloc/category/category_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryRepository repository;

  CategoryCubit(this.repository) : super(CategoryLoading());

  Future<void> fetchCategories() async {
    emit(CategoryLoading());

    final result = await repository.getCategories();

    result.fold(
      (failure) => emit(CategoryError(failure.message)),
      (categories) => emit(CategoryLoaded(categories)),
    );
  }
}
