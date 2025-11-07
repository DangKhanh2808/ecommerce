import 'package:flutter/material.dart';
import 'package:ecommerce/domain/order/entities/order.dart';
import 'package:ecommerce/service_locator.dart';
import 'package:ecommerce/domain/order/usecases/update_order_status.dart';

class AdminUpdateOrderStatusPage extends StatefulWidget {
  final OrderEntity order;

  const AdminUpdateOrderStatusPage({super.key, required this.order});

  @override
  State<AdminUpdateOrderStatusPage> createState() =>
      _AdminUpdateOrderStatusPageState();
}

class _AdminUpdateOrderStatusPageState
    extends State<AdminUpdateOrderStatusPage> {
  String? selectedStatus;

  final statuses = [
    "Order Placed",
    "Processing",
    "Shipped",
    "Delivered",
    "Cancelled"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Update Status")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Select New Status:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(border: OutlineInputBorder()),
              value: selectedStatus,
              items: statuses.map((e) {
                return DropdownMenuItem(value: e, child: Text(e));
              }).toList(),
              onChanged: (v) => setState(() => selectedStatus = v),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: selectedStatus == null
                  ? null
                  : () async {
                      final result = await sl<UpdateOrderStatusUseCase>().call(
                        code: widget.order.code,
                        status: selectedStatus!,
                        note: null,
                      );

                      result.fold(
                        (error) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text(error)));
                        },
                        (_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Status updated ✅")));
                          Navigator.pop(context);
                        },
                      );
                    },
              child: const Text("Update"),
            )
          ],
        ),
      ),
    );
  }
}
