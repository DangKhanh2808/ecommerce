import 'package:flutter_bloc/flutter_bloc.dart';
import 'order_status_event.dart';
import 'order_status_state.dart';
import 'package:ecommerce/domain/order/usecases/update_order_status.dart';
import 'package:ecommerce/service_locator.dart';

class OrderStatusBloc extends Bloc<OrderStatusEvent, OrderStatusState> {
  final UpdateOrderStatusUseCase useCase = sl<UpdateOrderStatusUseCase>();

  OrderStatusBloc() : super(OrderStatusInitial()) {
    on<UpdateOrderStatusEvent>((event, emit) async {
      emit(OrderStatusLoading());

      final result = await useCase(
        code: event.code,
        status: event.status,
        note: event.note,
      );

      result.fold(
        (error) => emit(OrderStatusFailure(error)),
        (success) => emit(OrderStatusSuccess(success)),
      );
    });
  }
}
