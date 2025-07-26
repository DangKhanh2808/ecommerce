part of 'review_cubit.dart';

abstract class ReviewState {}

class ReviewInitial extends ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewLoaded extends ReviewState {
  final List<ReviewEntity> reviews;

  ReviewLoaded(this.reviews);
}

class ReviewError extends ReviewState {
  final String message;

  ReviewError(this.message);
}

class ReviewSubmitting extends ReviewState {}

class ReviewSubmitSuccess extends ReviewState {}

class ReviewSubmitError extends ReviewState {
  final String message;

  ReviewSubmitError(this.message);
}
