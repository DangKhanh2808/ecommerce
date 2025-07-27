import 'package:flutter/material.dart';
import 'package:ecommerce/domain/auth/entity/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/presentation/home/admin/bloc/user_management_cubit.dart';

class AdminUserManagementPage extends StatefulWidget {
  final UserEntity user;
  const AdminUserManagementPage({Key? key, required this.user}) : super(key: key);

  @override
  State<AdminUserManagementPage> createState() => _AdminUserManagementPageState();
}

class _AdminUserManagementPageState extends State<AdminUserManagementPage> {
  late UserEntity user;
  @override
  void initState() {
    super.initState();
    user = widget.user;
  }

  void showEditAddressDialog() async {
    final controller = TextEditingController(text: user.address ?? '');
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Address for ${user.firstName} ${user.lastName}'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Shipping Address'),
          minLines: 1,
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (result != null && result != user.address) {
      final cubit = context.read<UserManagementCubit>();
      await cubit.updateAddress(user.userId, result);
      // Sau khi cập nhật, lấy lại user mới nhất từ state
      final state = cubit.state;
      if (state is UserManagementLoaded) {
        final updated = state.users.firstWhere((u) => u.userId == user.userId, orElse: () => user);
        setState(() => user = updated);
      }
    }
  }

  void showEditPaymentMethodDialog() async {
    final controller = TextEditingController(text: user.paymentMethod ?? 'PayPal');
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Payment Method for ${user.firstName} ${user.lastName}'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Payment Method'),
          minLines: 1,
          maxLines: 1,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (result != null && result != user.paymentMethod) {
      final cubit = context.read<UserManagementCubit>();
      await cubit.updatePaymentMethod(user.userId, result);
      // Sau khi cập nhật, lấy lại user mới nhất từ state
      final state = cubit.state;
      if (state is UserManagementLoaded) {
        final updated = state.users.firstWhere((u) => u.userId == user.userId, orElse: () => user);
        setState(() => user = updated);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Address Management')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: user.image.isNotEmpty ? NetworkImage(user.image) : null,
              child: user.image.isEmpty ? const Icon(Icons.person) : null,
            ),
            title: Text('${user.firstName} ${user.lastName}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Email: ${user.email}'),
                Text('Address: ${user.address ?? 'No address'}'),
                Text('Payment: ${user.paymentMethod ?? 'PayPal'}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: showEditAddressDialog,
                  tooltip: 'Edit Address',
                ),
                IconButton(
                  icon: const Icon(Icons.account_balance_wallet),
                  onPressed: showEditPaymentMethodDialog,
                  tooltip: 'Edit Payment Method',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 