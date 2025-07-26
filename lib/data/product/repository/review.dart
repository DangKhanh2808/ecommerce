import 'package:ecommerce/data/product/models/review.dart';
import 'package:ecommerce/data/product/source/review_firebase_service.dart';
import 'package:ecommerce/domain/product/entity/review.dart';
import 'package:ecommerce/domain/product/repository/review.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewFirebaseService service;

  ReviewRepositoryImpl(this.service);

  @override
  Future<void> submitReview(ReviewEntity review) {
    return service.submitReview(ReviewModel.fromEntity(review));
  }

  @override
  Future<List<ReviewEntity>> getReviews(String productId) async {
    final models = await service.getReviews(productId);
    return models.map((e) => e.toEntity()).toList();
  }
}
