import 'package:ecommerce/data/auth/repository/auth_respository_imple.dart';
import 'package:ecommerce/data/auth/sources/auth_firebase_service.dart';
import 'package:ecommerce/data/category/repository/category.dart';
import 'package:ecommerce/data/category/sources/category_firebase_service.dart';
import 'package:ecommerce/data/product/repository/product.dart';
import 'package:ecommerce/data/product/source/product_firebase_service.dart';
import 'package:ecommerce/domain/auth/repository/auth.dart';
import 'package:ecommerce/domain/auth/usecases/get_ages.dart';
import 'package:ecommerce/domain/auth/usecases/get_user.dart';
import 'package:ecommerce/domain/auth/usecases/is_logged_in.dart';
import 'package:ecommerce/domain/auth/usecases/send_password_reset_email.dart';
import 'package:ecommerce/domain/auth/usecases/signin.dart';
import 'package:ecommerce/domain/auth/usecases/signup.dart';
import 'package:ecommerce/domain/category/repository/category.dart';
import 'package:ecommerce/domain/category/usecases/get_categories.dart';
import 'package:ecommerce/domain/product/repository/product.dart';
import 'package:ecommerce/domain/product/usecases/get_new_in.dart';
import 'package:ecommerce/domain/product/usecases/get_products_by_category_id.dart';
import 'package:ecommerce/domain/product/usecases/get_products_by_title.dart';
import 'package:ecommerce/domain/product/usecases/get_top_selling.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
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
}
