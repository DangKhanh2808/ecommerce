import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/data/product/models/review.dart';

abstract class ReviewFirebaseService {
  Future<void> submitReview(ReviewModel review);
  Future<List<ReviewModel>> getReviews(String productId);
}

class ReviewFirebaseServiceImpl implements ReviewFirebaseService {
  final FirebaseFirestore firestore;

  ReviewFirebaseServiceImpl({required this.firestore});

  @override
  Future<void> submitReview(ReviewModel review) async {
    await firestore
        .collection('products')
        .doc(review.productId)
        .collection('reviews')
        .doc(review.reviewId)
        .set(review.toMap());
  }

  @override
  Future<List<ReviewModel>> getReviews(String productId) async {
    final snapshot = await firestore
        .collection('products')
        .doc(productId)
        .collection('reviews')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((e) => ReviewModel.fromMap(e.data())).toList();
  }
}
