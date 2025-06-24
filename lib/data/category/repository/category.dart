import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/error/failure.dart';
import 'package:ecommerce/data/category/models/category.dart';
import 'package:ecommerce/data/category/sources/category_firebase_service.dart';
import 'package:ecommerce/domain/category/entity/category.dart';
import 'package:ecommerce/domain/category/repository/category.dart';
import 'package:ecommerce/service_locator.dart';

class CategoryRepositoryImpl extends CategoryRepository {
  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    var category = await sl<CategoryFirebaseService>().getCategories();
    return category.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(data)
              .map((e) => CategoryModel.fromMap(e).toEntity())
              .toList(),
        );
      },
    );
  }
}
