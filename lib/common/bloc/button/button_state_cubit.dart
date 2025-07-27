import 'package:dartz/dartz.dart';
import 'package:ecommerce/common/bloc/button/button_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/usecase/usecase.dart';

class ButtonStateCubit extends Cubit<ButtonState> {
  ButtonStateCubit() : super(ButtonInitialState());

  Future<void> execute({dynamic params, required UseCase usecase}) async {
    print('🔄 ButtonStateCubit.execute() called');
    print('📦 Params: $params');
    print('🎯 UseCase: ${usecase.runtimeType}');
    
    emit(ButtonLoadingState());
    print('⏳ ButtonLoadingState emitted');
    
    try {
      print('🚀 Calling usecase.call()...');
      Either returnedData = await usecase.call(params: params);
      print('📡 UseCase returned: $returnedData');
      
      returnedData.fold((error) {
        print('❌ UseCase failed: $error');
        emit(ButtonFailureState(errorMessage: error));
        print('💥 ButtonFailureState emitted');
      }, (data) {
        print('✅ UseCase succeeded: $data');
        emit(ButtonSuccessState());
        print('🎉 ButtonSuccessState emitted');
      });
    } catch (e) {
      print('💥 Exception caught: $e');
      emit(ButtonFailureState(errorMessage: e.toString()));
      print('💥 ButtonFailureState emitted (exception)');
    }
  }
}
