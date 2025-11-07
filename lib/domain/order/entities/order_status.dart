class OrderStatusEntity {
  final String title;
  final bool done;
  final DateTime createdDate;
  final String? note;

  OrderStatusEntity({
    required this.title,
    required this.done,
    required this.createdDate,
    this.note,
  });
}
