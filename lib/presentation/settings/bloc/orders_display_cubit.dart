import 'package:ecommerce/domain/order/usecases/get_orders.dart';
import 'package:ecommerce/presentation/settings/bloc/order_display_state.dart';
import 'package:ecommerce/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersDisplayCubit extends Cubit<OrdersDisplayState> {
  OrdersDisplayCubit() : super(OrdersLoading());

  Future<void> displayOrders() async {
    // Don't start if already closed
    if (isClosed) return;
    
    // Emit loading state
    _safeEmit(OrdersLoading());

    try {
      final returnedData = await sl<GetOrdersUseCase>().call();

      // Check if cubit is still active before emitting
      if (!isClosed) {
        returnedData.fold(
          (error) {
            _safeEmit(LoadOrdersFailure(errorMessage: error));
          },
          (orders) {
            _safeEmit(OrdersLoaded(orders: orders));
          },
        );
      }
    } catch (e) {
      // Check if cubit is still active before emitting error
      _safeEmit(LoadOrdersFailure(errorMessage: 'An unexpected error occurred: $e'));
    }
  }

  // Helper method to safely emit states
  void _safeEmit(OrdersDisplayState state) {
    if (!isClosed) {
      emit(state);
    }
  }

  @override
  Future<void> close() {
    // Ensure no more emissions after close
    return super.close();
  }
}
