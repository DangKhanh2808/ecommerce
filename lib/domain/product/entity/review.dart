class ReviewEntity {
  final String? reviewId; // Có thể null khi tạo mới
  final String productId;
  final String userId;
  final String userName;
  final String content;
  final int rating;
  final DateTime createdAt;

  ReviewEntity({
    this.reviewId, // Không bắt buộc nữa
    required this.productId,
    required this.userId,
    required this.userName,
    required this.content,
    required this.rating,
    required this.createdAt,
  });
}
