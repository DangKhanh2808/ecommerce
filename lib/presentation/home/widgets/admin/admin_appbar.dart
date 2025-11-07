import 'package:ecommerce/presentation/admin/get_orders/views/admin_order_list_page.dart';
import 'package:flutter/material.dart';
import 'admin_user_menu.dart';

class AdminAppBar extends StatelessWidget {
  const AdminAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("Admin Dashboard"),
      actions: [
        const AdminUserMenu(),
        IconButton(
          icon: const Icon(Icons.list_alt),
          tooltip: "Orders",
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AdminOrderListPage(),
              ),
            );
          },
        )
      ],
    );
  }
}
