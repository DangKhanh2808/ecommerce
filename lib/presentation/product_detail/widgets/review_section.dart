import 'package:ecommerce/domain/product/entity/review.dart';
import 'package:ecommerce/presentation/product_detail/bloc/review_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

class ReviewSection extends StatefulWidget {
  final String productId;
  final String userId;
  final String userName;

  const ReviewSection({
    super.key,
    required this.productId,
    required this.userId,
    required this.userName,
  });

  @override
  State<ReviewSection> createState() => _ReviewSectionState();
}

class _ReviewSectionState extends State<ReviewSection> {
  final _controller = TextEditingController();
  double _rating = 5;

  @override
  void initState() {
    super.initState();
    context.read<ReviewCubit>().loadReviews(widget.productId);
  }

  void _submitReview() {
    final content = _controller.text.trim();
    if (content.isEmpty) return;

    final review = ReviewEntity(
      productId: widget.productId,
      userId: widget.userId,
      userName: widget.userName,
      content: content,
      rating: _rating.toInt(),
      createdAt: DateTime.now(),
    );

    context.read<ReviewCubit>().submitReview(review);
    _controller.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(12.0),
          child: Text('Product Review',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        BlocConsumer<ReviewCubit, ReviewState>(
          listener: (context, state) {
            if (state is ReviewSubmitSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Review submitted')),
              );
            } else if (state is ReviewSubmitError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Failed to submit review: ${state.message}')),
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  RatingBar.builder(
                    initialRating: 5,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemSize: 30,
                    itemBuilder: (context, _) =>
                        const Icon(Icons.star, color: Colors.amber),
                    onRatingUpdate: (rating) {
                      _rating = rating;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _controller,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'Write your review here...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed:
                          state is ReviewSubmitting ? null : _submitReview,
                      child: state is ReviewSubmitting
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : const Text('Submit Review'),
                    ),
                  )
                ],
              ),
            );
          },
        ),
        BlocBuilder<ReviewCubit, ReviewState>(
          builder: (context, state) {
            if (state is ReviewLoading) {
              return const Padding(
                padding: EdgeInsets.all(12.0),
                child: Center(child: CircularProgressIndicator()),
              );
            } else if (state is ReviewLoaded) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: state.reviews.map((r) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text(r.userName),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: List.generate(
                                  5,
                                  (index) => Icon(
                                        index < r.rating
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: Colors.amber,
                                        size: 16,
                                      )),
                            ),
                            const SizedBox(height: 4),
                            Text(r.content),
                            Text(
                              DateFormat('dd/MM/yyyy – HH:mm')
                                  .format(r.createdAt),
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                    ],
                  );
                }).toList(),
              );
            } else if (state is ReviewError) {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text('Error: ${state.message}',
                    style: const TextStyle(color: Colors.red)),
              );
            }
            return const SizedBox();
          },
        )
      ],
    );
  }
}
