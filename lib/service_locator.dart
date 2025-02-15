import 'package:ecommerce/data/auth/respository/auth_respository_imple.dart';
import 'package:ecommerce/data/auth/sources/auth_firebase_service.dart';
import 'package:ecommerce/domain/auth/respository/auth.dart';
import 'package:ecommerce/domain/auth/usecases/get_ages.dart';
import 'package:ecommerce/domain/auth/usecases/get_user.dart';
import 'package:ecommerce/domain/auth/usecases/is_logged_in.dart';
import 'package:ecommerce/domain/auth/usecases/send_password_reset_email.dart';
import 'package:ecommerce/domain/auth/usecases/signin.dart';
import 'package:ecommerce/domain/auth/usecases/signup.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  //Services

  sl.registerSingleton<AuthFirebaseService>(
    AuthFirebaseServiceImpl(),
  );

  //Repositories

  sl.registerSingleton<AuthRepository>(
    AuthRespositoryImple(),
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
}
