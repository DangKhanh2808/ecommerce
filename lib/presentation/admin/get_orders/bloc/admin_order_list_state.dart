import 'package:ecommerce/domain/order/entities/order.dart';

abstract class AdminOrderListState {}

class AdminOrderListInitial extends AdminOrderListState {}

class AdminOrderListLoading extends AdminOrderListState {}

class AdminOrderListLoaded extends AdminOrderListState {
  final List<OrderEntity> orders;
  AdminOrderListLoaded(this.orders);
}

class AdminOrderListEmpty extends AdminOrderListState {}

class AdminOrderListError extends AdminOrderListState {
  final String message;
  AdminOrderListError(this.message);
}
