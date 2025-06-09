import 'package:ecommerce/domain/auth/usecases/get_role.dart';
import 'package:ecommerce/domain/auth/usecases/is_logged_in.dart';
import 'package:ecommerce/presentation/splash/bloc/splash_state.dart';
import 'package:ecommerce/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(DisplaySplashState());

  void appStarted() async {
    await Future.delayed(Duration(seconds: 2));
    var isLoggedIn = await sl<IsLoggedInUseCase>().call();
    final role = await sl<GetRoleUseCase>().call();
    if (isLoggedIn) {
      emit(
        AuthenticatedState(role),
      );
    } else {
      emit(
        UnAuthenticatedState(),
      );
    }
  }
}
