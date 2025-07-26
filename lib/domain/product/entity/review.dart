class ReviewEntity {
  final String reviewId;
  final String productId;
  final String userId;
  final String userName;
  final String content;
  final int rating;
  final DateTime createdAt;

  ReviewEntity({
    required this.reviewId,
    required this.productId,
    required this.userId,
    required this.userName,
    required this.content,
    required this.rating,
    required this.createdAt,
  });
}
