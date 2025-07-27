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
    // Sử dụng Firebase auto-generated ID thay vì reviewId từ model
    final reviewData = review.toMap();
    // Loại bỏ reviewId vì Firebase sẽ tự tạo
    reviewData.remove('reviewId');
    
    final docRef = await firestore
        .collection('Products')
        .doc(review.productId)
        .collection('reviews')
        .add(reviewData);
    
    // Cập nhật lại reviewId với ID thực tế từ Firebase
    await docRef.update({'reviewId': docRef.id});
  }

  @override
  Future<List<ReviewModel>> getReviews(String productId) async {
    final snapshot = await firestore
        .collection('Products')
        .doc(productId)
        .collection('reviews')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((e) {
      final data = e.data();
      data['reviewId'] = e.id; // Sử dụng document ID làm reviewId
      return ReviewModel.fromMap(data);
    }).toList();
  }
}
