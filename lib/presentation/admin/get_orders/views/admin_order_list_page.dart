import 'package:ecommerce/presentation/admin/order_detail/views/admin_order_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/presentation/admin/get_orders/bloc/admin_order_list_bloc.dart';
import 'package:ecommerce/presentation/admin/get_orders/bloc/admin_order_list_state.dart';
import 'package:ecommerce/presentation/admin/get_orders/bloc/admin_order_list_event.dart';

class AdminOrderListPage extends StatelessWidget {
  const AdminOrderListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminOrderListBloc()..add(LoadAdminOrdersEvent()),
      child: Scaffold(
        appBar: AppBar(title: const Text("All Orders")),
        body: BlocBuilder<AdminOrderListBloc, AdminOrderListState>(
          builder: (context, state) {
            if (state is AdminOrderListLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is AdminOrderListError) {
              return Center(child: Text(state.message));
            }

            if (state is AdminOrderListLoaded) {
              return ListView.separated(
                itemCount: state.orders.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final order = state.orders[index];
                  return ListTile(
                    title: Text("Order #${order.code}"),
                    subtitle: Text("${order.itemCount} items - ${order.totalPrice}₫"),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AdminOrderDetailPage(order: order),
                        ),
                      );
                    },
                  );
                },
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
