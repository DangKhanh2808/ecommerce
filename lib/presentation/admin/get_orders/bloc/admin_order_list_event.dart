abstract class AdminOrderListEvent {}

class LoadAdminOrdersEvent extends AdminOrderListEvent {}

class SearchAdminOrdersEvent extends AdminOrderListEvent {
  final String query;
  SearchAdminOrdersEvent(this.query);
}
