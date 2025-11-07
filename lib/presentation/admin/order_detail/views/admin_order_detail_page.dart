import 'package:ecommerce/presentation/admin/update_order_status/admin_order_update_status.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/domain/order/entities/order.dart';

class AdminOrderDetailPage extends StatelessWidget {
  final OrderEntity order;

  const AdminOrderDetailPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order ${order.code}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AdminUpdateOrderStatusPage(order: order),
                ),
              );
            },
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text("Shipping: ${order.shippingAddress}"),
          const SizedBox(height: 10),
          Text("Total: ${order.totalPrice}"),
          const SizedBox(height: 20),

          const Text("Statuses",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

          ...order.orderStatus.map((s) {
            return ListTile(
              leading: Icon(
                s.done ? Icons.check_circle : Icons.circle_outlined,
                color: s.done ? Colors.green : Colors.grey,
              ),
              title: Text(s.title),
              subtitle: Text(s.createdDate.toString()),
            );
          })
        ],
      ),
    );
  }
}
