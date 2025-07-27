import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/presentation/home/admin/bloc/user_management_cubit.dart';
import 'package:ecommerce/domain/auth/entity/user.dart';

class AdminAllUserAddressesPage extends StatelessWidget {
  const AdminAllUserAddressesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserManagementCubit(
        getAllUsersUseCase: context.read(),
        updateUserAddressUseCase: context.read(),
        updateUserPaymentMethodUseCase: context.read(),
      )..fetchUsers(),
      child: Scaffold(
        appBar: AppBar(title: const Text('All User Addresses')),
        body: BlocBuilder<UserManagementCubit, UserManagementState>(
          builder: (context, state) {
            if (state is UserManagementLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is UserManagementError) {
              return Center(child: Text(state.message));
            }
            if (state is UserManagementLoaded) {
              final users = state.users;
              if (users.isEmpty) {
                return const Center(child: Text('No users found.'));
              }
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Email')),
                    DataColumn(label: Text('Phone')),
                    DataColumn(label: Text('Address')),
                    DataColumn(label: Text('Payment')),
                  ],
                  rows: users.map((user) => DataRow(cells: [
                    DataCell(Text('${user.firstName} ${user.lastName}')),
                    DataCell(Text(user.email)),
                    DataCell(Text(user.phone ?? '')),
                    DataCell(Text(user.address ?? '')),
                    DataCell(Text(user.paymentMethod ?? 'PayPal')),
                  ])).toList(),
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
} 