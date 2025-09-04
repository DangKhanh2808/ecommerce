import 'package:ecommerce/common/bloc/button/button_state_cubit.dart';
import 'package:ecommerce/common/widgets/appbar/app_bar.dart';
import 'package:ecommerce/domain/auth/usecases/get_user.dart';
import 'package:ecommerce/domain/product/entity/product.dart';
import 'package:ecommerce/presentation/product_detail/bloc/favorite_icon_cubit.dart';
import 'package:ecommerce/presentation/product_detail/bloc/product_color_selection_cubit.dart';
import 'package:ecommerce/presentation/product_detail/bloc/product_quantity_cubit.dart';
import 'package:ecommerce/presentation/product_detail/bloc/product_size_selection_cubit.dart';
import 'package:ecommerce/presentation/product_detail/bloc/review_cubit.dart';
import 'package:ecommerce/presentation/product_detail/widgets/add_to_bag.dart';
import 'package:ecommerce/presentation/product_detail/widgets/favorite_button.dart';
import 'package:ecommerce/presentation/product_detail/widgets/product_images.dart';
import 'package:ecommerce/presentation/product_detail/widgets/product_price.dart';
import 'package:ecommerce/presentation/product_detail/widgets/product_quantity.dart';
import 'package:ecommerce/presentation/product_detail/widgets/product_title.dart';
import 'package:ecommerce/presentation/product_detail/widgets/review_section.dart';
import 'package:ecommerce/presentation/product_detail/widgets/selected_color.dart';
import 'package:ecommerce/presentation/product_detail/widgets/selected_size.dart';
import 'package:ecommerce/presentation/product_detail/widgets/related_products_section.dart';
import 'package:ecommerce/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/domain/product/usecases/submit_review.dart';
import 'package:ecommerce/domain/product/usecases/get_review.dart';

class ProductDetailPage extends StatelessWidget {
  final ProductEntity productEntity;

  const ProductDetailPage({
    super.key,
    required this.productEntity,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ProductQuantityCubit()),
        BlocProvider(create: (_) => ProductColorSelectionCubit()),
        BlocProvider(create: (_) => ProductSizeSelectionCubit()),
        BlocProvider(create: (_) => FavoriteIconCubit()),
        BlocProvider(
          create: (_) => ReviewCubit(
            submitReviewUseCase: sl<SubmitReviewUseCase>(),
            getReviewsUseCase: sl<GetReviewsUseCase>(),
          ),
        ),
        BlocProvider(create: (_) => ButtonStateCubit()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Product Detail'),
          actions: [
            FavoriteButton(productEntity: productEntity),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProductImages(productEntity: productEntity),
              const SizedBox(height: 16),
              ProductTitle(productEntity: productEntity),
              const SizedBox(height: 8),
              ProductPrice(productEntity: productEntity),
              const SizedBox(height: 16),
              ProductQuantity(productEntity: productEntity),
              const SizedBox(height: 16),
              SelectedColor(productEntity: productEntity),
              const SizedBox(height: 8),
              SelectedSize(productEntity: productEntity),
              const SizedBox(height: 16),
              AddToBag(productEntity: productEntity),
              const SizedBox(height: 24),
              ReviewSection(
                productId: productEntity.productId,
                userId: '', // Cần truyền userId thực tế nếu có
                userName: '', // Cần truyền userName thực tế nếu có
              ),
              // Nếu muốn có thể thêm RelatedProductsSection ở đây
            ],
          ),
        ),
      ),
    );
  }
}
