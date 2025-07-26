import 'package:ecommerce/domain/product/entity/review.dart';
import 'package:ecommerce/domain/product/repository/review.dart';

class GetReviewsUseCase {
  final ReviewRepository repository;

  GetReviewsUseCase(this.repository);

  Future<List<ReviewEntity>> call(String productId) async {
    return await repository.getReviews(productId);
  }
}
