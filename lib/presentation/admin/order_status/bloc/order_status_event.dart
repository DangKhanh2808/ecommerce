abstract class OrderStatusEvent {}

class UpdateOrderStatusEvent extends OrderStatusEvent {
  final String code;
  final String status;
  final String? note;

  UpdateOrderStatusEvent({
    required this.code,
    required this.status,
    this.note,
  });
}
