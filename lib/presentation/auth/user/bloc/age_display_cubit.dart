import 'package:ecommerce/domain/auth/usecases/get_ages.dart';
import 'package:ecommerce/presentation/auth/user/bloc/age_display_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../service_locator.dart';

class AgesDisplayCubit extends Cubit<AgesDisplayState> {
  AgesDisplayCubit() : super(AgesLoading());

  void displayAges() async {
    var returnedData = await sl<GetAgesUseCase>().call();

    returnedData.fold((message) {
      emit(AgesLoadFailure(message: message));
    }, (data) {
      emit(AgesLoaded(ages: data));
    });
  }
}
