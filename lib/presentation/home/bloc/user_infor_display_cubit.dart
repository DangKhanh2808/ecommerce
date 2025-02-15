import 'package:ecommerce/domain/auth/usecases/get_user.dart';
import 'package:ecommerce/presentation/home/bloc/user_infor_display_state.dart';
import 'package:ecommerce/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserInforDisplayCubit extends Cubit<UserInforDisplayState> {
  UserInforDisplayCubit() : super(UserInforLoading());

  void displayUserInfor() async {
    var returnedData = await sl<GetUserUseCase>().call();
    returnedData.fold(
      (error) {
        emit(LoadUserInforFailure());
      },
      (data) {
        emit(UserInforLoaded(user: data));
      },
    );
  }
}
