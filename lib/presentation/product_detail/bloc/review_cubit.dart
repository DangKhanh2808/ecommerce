import 'package:ecommerce/domain/product/entity/review.dart';
import 'package:ecommerce/domain/product/usecases/get_review.dart';
import 'package:ecommerce/domain/product/usecases/submit_review.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'review_state.dart';

class ReviewCubit extends Cubit<ReviewState> {
  final SubmitReviewUseCase submitReviewUseCase;
  final GetReviewsUseCase getReviewsUseCase;

  ReviewCubit({
    required this.submitReviewUseCase,
    required this.getReviewsUseCase,
  }) : super(ReviewInitial());

  Future<void> loadReviews(String productId) async {
    emit(ReviewLoading());
    try {
      final reviews = await getReviewsUseCase(productId);
      emit(ReviewLoaded(reviews));
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }

  Future<void> submitReview(ReviewEntity review) async {
    emit(ReviewSubmitting());
    try {
      await submitReviewUseCase(review);
      emit(ReviewSubmitSuccess());
      await loadReviews(review.productId); // Optional: refresh
    } catch (e) {
      emit(ReviewSubmitError(e.toString()));
    }
  }
}
