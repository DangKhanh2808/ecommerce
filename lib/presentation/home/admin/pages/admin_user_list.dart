import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/presentation/home/admin/bloc/user_management_cubit.dart';
import 'package:ecommerce/domain/auth/entity/user.dart';
import 'admin_user_management.dart';

class AdminUserListPage extends StatelessWidget {
  const AdminUserListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserManagementCubit(
        getAllUsersUseCase: context.read(),
        updateUserAddressUseCase: context.read(),
        updateUserPaymentMethodUseCase: context.read(),
      )..fetchUsers(),
      child: Scaffold(
        appBar: AppBar(title: const Text('User Management')),
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
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: users.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final user = users[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: user.image.isNotEmpty ? NetworkImage(user.image) : null,
                      child: user.image.isEmpty ? const Icon(Icons.person) : null,
                    ),
                    title: Text('${user.firstName} ${user.lastName}'),
                    subtitle: Text(user.email),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      final cubit = context.read<UserManagementCubit>();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: cubit,
                            child: AdminUserManagementPage(user: user),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
} 