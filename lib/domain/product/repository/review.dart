import 'package:ecommerce/domain/product/entity/review.dart';

abstract class ReviewRepository {
  Future<void> submitReview(ReviewEntity review);
  Future<List<ReviewEntity>> getReviews(String productId);
}
