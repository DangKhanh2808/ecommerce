import 'package:ecommerce/domain/product/entity/review.dart';
import 'package:ecommerce/domain/product/repository/review.dart';

class SubmitReviewUseCase {
  final ReviewRepository repository;

  SubmitReviewUseCase(this.repository);

  Future<void> call(ReviewEntity review) async {
    await repository.submitReview(review);
  }
}
