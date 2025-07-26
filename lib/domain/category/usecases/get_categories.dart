import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/usecase/usecase.dart';
import 'package:ecommerce/domain/category/repository/category.dart';

class GetCategoriesUseCase implements UseCase<Either, dynamic> {
  final CategoryRepository repository;

  GetCategoriesUseCase(this.repository);

  @override
  Future<Either> call({params}) async {
    return await repository.getCategories();
  }
}
