import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/domain/product/entity/review.dart';

class ReviewModel {
  final String reviewId;
  final String productId;
  final String userId;
  final String userName;
  final String content;
  final int rating;
  final Timestamp createdAt;

  ReviewModel({
    required this.reviewId,
    required this.productId,
    required this.userId,
    required this.userName,
    required this.content,
    required this.rating,
    required this.createdAt,
  });

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      reviewId: map['reviewId'] ?? '',
      productId: map['productId'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      content: map['content'] ?? '',
      rating: map['rating'] ?? 5,
      createdAt: map['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'reviewId': reviewId,
      'productId': productId,
      'userId': userId,
      'userName': userName,
      'content': content,
      'rating': rating,
      'createdAt': createdAt,
    };
  }

  ReviewEntity toEntity() {
    return ReviewEntity(
      reviewId: reviewId,
      productId: productId,
      userId: userId,
      userName: userName,
      content: content,
      rating: rating,
      createdAt: createdAt.toDate(),
    );
  }

  static ReviewModel fromEntity(ReviewEntity entity) {
    return ReviewModel(
      reviewId: entity.reviewId,
      productId: entity.productId,
      userId: entity.userId,
      userName: entity.userName,
      content: entity.content,
      rating: entity.rating,
      createdAt: Timestamp.fromDate(entity.createdAt),
    );
  }
}
