import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/data/auth/repository/auth_respository_imple.dart';
import 'package:ecommerce/data/auth/sources/auth_firebase_service.dart';
import 'package:ecommerce/data/category/repository/category.dart';
import 'package:ecommerce/data/category/sources/category_firebase_service.dart';
import 'package:ecommerce/data/order/repository/order.dart';
import 'package:ecommerce/data/order/source/order_firebase_service.dart';
import 'package:ecommerce/data/product/repository/product.dart';
import 'package:ecommerce/data/product/repository/review.dart';
import 'package:ecommerce/data/product/source/product_firebase_service.dart';
import 'package:ecommerce/data/product/source/review_firebase_service.dart';
import 'package:ecommerce/data/storage/repository/storage.dart';
import 'package:ecommerce/domain/auth/repository/auth.dart';
import 'package:ecommerce/domain/auth/usecases/get_ages.dart';
import 'package:ecommerce/domain/auth/usecases/get_role.dart';
import 'package:ecommerce/domain/auth/usecases/get_user.dart';
import 'package:ecommerce/domain/auth/usecases/is_logged_in.dart';
import 'package:ecommerce/domain/auth/usecases/send_password_reset_email.dart';
import 'package:ecommerce/domain/auth/usecases/signin.dart';
import 'package:ecommerce/domain/auth/usecases/signout.dart';
import 'package:ecommerce/domain/auth/usecases/signup.dart';
import 'package:ecommerce/domain/category/repository/category.dart';
import 'package:ecommerce/domain/category/usecases/get_categories.dart';
import 'package:ecommerce/domain/order/repository/order.dart';
import 'package:ecommerce/domain/order/usecases/add_to_cart.dart';
import 'package:ecommerce/domain/order/usecases/get_cart_products.dart';
import 'package:ecommerce/domain/order/usecases/get_orders.dart';
import 'package:ecommerce/domain/order/usecases/order_registration.dart';
import 'package:ecommerce/domain/order/usecases/remove_cart_products.dart';
import 'package:ecommerce/domain/product/repository/product.dart';
import 'package:ecommerce/domain/product/repository/review.dart';
import 'package:ecommerce/domain/product/usecases/add_or_remove_favorite_product.dart';
import 'package:ecommerce/domain/product/usecases/add_product.dart';
import 'package:ecommerce/domain/product/usecases/delete_product.dart';
import 'package:ecommerce/domain/product/usecases/get_favorites_products.dart';
import 'package:ecommerce/domain/product/usecases/get_new_in.dart';
import 'package:ecommerce/domain/product/usecases/get_products_by_category_id.dart';
import 'package:ecommerce/domain/product/usecases/get_products_by_title.dart';
import 'package:ecommerce/domain/product/usecases/get_review.dart';
import 'package:ecommerce/domain/product/usecases/get_top_selling.dart';
import 'package:ecommerce/domain/product/usecases/is_favorite.dart';
import 'package:ecommerce/domain/product/usecases/submit_review.dart';
import 'package:ecommerce/domain/product/usecases/update_product.dart';
import 'package:ecommerce/domain/storage/repository/storage.dart';
import 'package:ecommerce/domain/storage/usecase/upload_product_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // External dependencies
  sl.registerLazySingleton(() => FirebaseStorage.instance);
  sl.registerLazySingleton(() => Uuid());
  sl.registerLazySingleton(() => FirebaseFirestore.instance);

  //Services

  sl.registerSingleton<AuthFirebaseService>(
    AuthFirebaseServiceImpl(),
  );

  sl.registerSingleton<CategoryFirebaseService>(
    CategoryFirebaseServiceImpl(),
  );

  sl.registerSingleton<ProductFirebaseService>(
    ProductFirebaseServiceImpl(),
  );

  sl.registerSingleton<OrderFirebaseService>(
    OrderFirebaseServiceImpl(),
  );

  sl.registerSingleton<ReviewFirebaseService>(
    ReviewFirebaseServiceImpl(firestore: sl()),
  );

  //Repositories

  sl.registerSingleton<AuthRepository>(
    AuthrepositoryImple(),
  );

  sl.registerSingleton<CategoryRepository>(
    CategoryRepositoryImpl(),
  );

  sl.registerSingleton<ProductRepository>(
    ProductRepositoryImpl(),
  );

  sl.registerSingleton<OrderRepository>(
    OrderRepositoryImpl(),
  );

  sl.registerSingleton<StorageRepository>(
    StorageRepositoryImpl(
      firebaseStorage: sl(),
      uuid: sl(),
    ),
  );

  sl.registerSingleton<ReviewRepository>(
    ReviewRepositoryImpl(sl<ReviewFirebaseService>()),
  );
  //UseCases

  sl.registerSingleton<SignupUseCase>(
    SignupUseCase(),
  );

  sl.registerSingleton<GetAgesUseCase>(
    GetAgesUseCase(),
  );

  sl.registerSingleton<SigninUseCase>(
    SigninUseCase(),
  );

  sl.registerSingleton<SendPasswordResetEmailUseCase>(
    SendPasswordResetEmailUseCase(),
  );

  sl.registerSingleton<IsLoggedInUseCase>(
    IsLoggedInUseCase(),
  );

  sl.registerSingleton<GetUserUseCase>(
    GetUserUseCase(),
  );

  sl.registerSingleton<GetCategoriesUseCase>(
    GetCategoriesUseCase(),
  );

  sl.registerSingleton<GetTopSellingUseCase>(
    GetTopSellingUseCase(),
  );

  sl.registerSingleton<GetNewInUseCase>(
    GetNewInUseCase(),
  );

  sl.registerSingleton<GetProductsByCategoryIdUseCase>(
    GetProductsByCategoryIdUseCase(),
  );

  sl.registerSingleton<GetProductsByTitleUseCase>(
    GetProductsByTitleUseCase(),
  );

  sl.registerSingleton<AddToCartUseCase>(
    AddToCartUseCase(),
  );

  sl.registerSingleton<GetCartProductsUseCase>(
    GetCartProductsUseCase(),
  );

  sl.registerSingleton<RemoveCartProductsUseCase>(
    RemoveCartProductsUseCase(),
  );

  sl.registerSingleton<OrderRegistrationUseCase>(
    OrderRegistrationUseCase(),
  );

  sl.registerSingleton<AddOrRemoveFavoriteProductUseCase>(
    AddOrRemoveFavoriteProductUseCase(),
  );

  sl.registerSingleton<IsFavoriteUseCase>(
    IsFavoriteUseCase(),
  );

  sl.registerSingleton<GetFavoritesProductsUseCase>(
    GetFavoritesProductsUseCase(),
  );

  sl.registerSingleton<GetOrdersUseCase>(
    GetOrdersUseCase(),
  );

  sl.registerSingleton<SignoutUseCase>(
    SignoutUseCase(),
  );

  sl.registerSingleton<GetRoleUseCase>(
    GetRoleUseCase(),
  );

  sl.registerSingleton<AddProductUseCase>(
    AddProductUseCase(),
  );

  sl.registerSingleton<DeleteProductUseCase>(
    DeleteProductUseCase(),
  );

  sl.registerSingleton<UpdateProductUseCase>(
    UpdateProductUseCase(),
  );

  sl.registerSingleton<UploadProductImageUseCase>(
    UploadProductImageUseCase(sl<StorageRepository>()),
  );

  sl.registerSingleton<SubmitReviewUseCase>(
    SubmitReviewUseCase(sl<ReviewRepository>()),
  );

  sl.registerSingleton<GetReviewsUseCase>(
    GetReviewsUseCase(sl<ReviewRepository>()),
  );
}
