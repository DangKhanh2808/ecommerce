import 'package:flutter_bloc/flutter_bloc.dart';
import 'admin_order_list_event.dart';
import 'admin_order_list_state.dart';
import 'package:ecommerce/domain/order/usecases/admin_get_all_orders.dart';
import 'package:ecommerce/domain/order/entities/order.dart';
import 'package:ecommerce/service_locator.dart';

class AdminOrderListBloc extends Bloc<AdminOrderListEvent, AdminOrderListState> {
  final _useCase = sl<AdminGetAllOrdersUseCase>();

  /// ✅ MUST be List<OrderEntity> (THAY vì dynamic)
  List<OrderEntity> orders = [];

  AdminOrderListBloc() : super(AdminOrderListInitial()) {
    on<LoadAdminOrdersEvent>(_loadOrders);
    on<SearchAdminOrdersEvent>(_searchOrders);
  }

  // ==========================================================
  // ✅ LOAD ORDERS
  // ==========================================================
  Future<void> _loadOrders(
      LoadAdminOrdersEvent event, Emitter<AdminOrderListState> emit) async {
    emit(AdminOrderListLoading());

    final result = await _useCase();

    result.fold(
      (error) => emit(AdminOrderListError(error)),
      (data) {
        /// ✅ ÉP KIỂU CHUẨN   
        orders = List<OrderEntity>.from(data);

        if (orders.isEmpty) {
          emit(AdminOrderListEmpty());
        } else {
          emit(AdminOrderListLoaded(orders));
        }
      },
    );
  }

  // ==========================================================
  // ✅ SEARCH
  // ==========================================================
  void _searchOrders(
      SearchAdminOrdersEvent event, Emitter<AdminOrderListState> emit) {
    final query = event.query.toLowerCase();

    final filtered = orders.where((o) {
      return o.code.toLowerCase().contains(query) ||
          o.orderId.toLowerCase().contains(query);
    }).toList();

    if (filtered.isEmpty) {
      emit(AdminOrderListEmpty());
    } else {
      emit(AdminOrderListLoaded(filtered));
    }
  }
}
