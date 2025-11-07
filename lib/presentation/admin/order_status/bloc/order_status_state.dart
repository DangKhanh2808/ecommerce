abstract class OrderStatusState {}

class OrderStatusInitial extends OrderStatusState {}

class OrderStatusLoading extends OrderStatusState {}

class OrderStatusSuccess extends OrderStatusState {
  final String message;

  OrderStatusSuccess(this.message);
}

class OrderStatusFailure extends OrderStatusState {
  final String error;

  OrderStatusFailure(this.error);
}
