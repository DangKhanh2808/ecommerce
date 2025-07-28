import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/order/entities/payment_method.dart';
import '../../../domain/order/usecases/get_payment_methods.dart';
import '../../../domain/order/usecases/add_payment_method.dart';
import '../../../domain/order/usecases/delete_payment_method.dart';

abstract class PaymentMethodState {}
class PaymentMethodInitial extends PaymentMethodState {}
class PaymentMethodLoading extends PaymentMethodState {}
class PaymentMethodLoaded extends PaymentMethodState {
  final List<PaymentMethod> methods;
  PaymentMethodLoaded(this.methods);
}
class PaymentMethodError extends PaymentMethodState {
  final String message;
  PaymentMethodError(this.message);
}

class PaymentMethodCubit extends Cubit<PaymentMethodState> {
  final GetPaymentMethodsUseCase getMethods;
  final AddPaymentMethodUseCase addMethod;
  final DeletePaymentMethodUseCase deleteMethod;

  PaymentMethodCubit({
    required this.getMethods,
    required this.addMethod,
    required this.deleteMethod,
  }) : super(PaymentMethodInitial());

  Future<void> loadMethods(String userId) async {
    emit(PaymentMethodLoading());
    try {
      final methods = await getMethods(userId);
      emit(PaymentMethodLoaded(methods));
    } catch (e) {
      emit(PaymentMethodError(e.toString()));
    }
  }

  Future<void> addNewMethod(PaymentMethod method, String userId) async {
    try {
      await addMethod(method);
      await loadMethods(userId);
    } catch (e) {
      emit(PaymentMethodError(e.toString()));
    }
  }

  Future<void> deleteExistingMethod(String methodId, String userId) async {
    try {
      await deleteMethod(methodId, userId);
      await loadMethods(userId);
    } catch (e) {
      emit(PaymentMethodError(e.toString()));
    }
  }
} 