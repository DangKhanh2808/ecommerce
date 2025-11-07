import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/order_status_bloc.dart';
import '../bloc/order_status_event.dart';
import '../bloc/order_status_state.dart';

class AdminOrderStatusPage extends StatefulWidget {
  final String orderCode;

  const AdminOrderStatusPage({required this.orderCode, super.key});

  @override
  State<AdminOrderStatusPage> createState() => _AdminOrderStatusPageState();
}

class _AdminOrderStatusPageState extends State<AdminOrderStatusPage> {
  String? _selectedStatus;
  final TextEditingController _noteController = TextEditingController();

  final List<String> statuses = [
    "Processing",
    "Shipped",
    "Delivered",
    "Cancelled",
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrderStatusBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Update Order #${widget.orderCode}"),
        ),
        body: BlocConsumer<OrderStatusBloc, OrderStatusState>(
          listener: (context, state) {
            if (state is OrderStatusSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("✅ Status updated successfully"),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (state is OrderStatusFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("❌ ${state.error}"),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Select Status",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  DropdownButtonFormField<String>(
                    value: _selectedStatus,
                    items: statuses.map((s) {
                      return DropdownMenuItem(
                        value: s,
                        child: Text(s),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _selectedStatus = value);
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Choose status",
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Optional Note",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: _noteController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state is OrderStatusLoading
                          ? null
                          : () {
                              if (_selectedStatus == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Please select a status"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              BlocProvider.of<OrderStatusBloc>(context).add(
                                UpdateOrderStatusEvent(
                                  code: widget.orderCode,
                                  status: _selectedStatus!,
                                  note: _noteController.text.trim(),
                                ),
                              );
                            },
                      child: state is OrderStatusLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              "Update Status",
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
