import 'package:flutter/material.dart';
import 'package:ecommerce/presentation/home/admin/pages/admin_user_list.dart';
import 'package:ecommerce/presentation/home/admin/pages/admin_all_user_addresses.dart';
import 'package:ecommerce/domain/auth/repository/user_repository.dart';
import 'package:ecommerce/data/auth/repository/user_repository_impl.dart';
import 'package:ecommerce/domain/auth/usecases/get_all_users.dart';
import 'package:ecommerce/domain/auth/usecases/update_user_address.dart';
import 'package:ecommerce/domain/auth/usecases/update_user_payment_method.dart';
import 'package:provider/provider.dart';

class AdminUserMenu extends StatelessWidget {
  const AdminUserMenu({super.key});

  void _goToUserManagement(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiProvider(
          providers: [
            Provider<UserRepository>(create: (_) => UserRepositoryImpl()),
            Provider<GetAllUsersUseCase>(
                create: (context) =>
                    GetAllUsersUseCase(context.read<UserRepository>())),
            Provider<UpdateUserAddressUseCase>(
                create: (context) =>
                    UpdateUserAddressUseCase(context.read<UserRepository>())),
            Provider<UpdateUserPaymentMethodUseCase>(
                create: (context) => UpdateUserPaymentMethodUseCase(
                    context.read<UserRepository>())),
          ],
          child: const AdminUserListPage(),
        ),
      ),
    );
  }

  void _goToUserAddresses(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiProvider(
          providers: [
            Provider<UserRepository>(create: (_) => UserRepositoryImpl()),
            Provider<GetAllUsersUseCase>(
                create: (context) =>
                    GetAllUsersUseCase(context.read<UserRepository>())),
            Provider<UpdateUserAddressUseCase>(
                create: (context) =>
                    UpdateUserAddressUseCase(context.read<UserRepository>())),
            Provider<UpdateUserPaymentMethodUseCase>(
                create: (context) => UpdateUserPaymentMethodUseCase(
                    context.read<UserRepository>())),
          ],
          child: const AdminAllUserAddressesPage(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        IconButton(
          icon: const Icon(Icons.people),
          tooltip: 'User Management',
          onPressed: () => _goToUserManagement(context),
        ),
        IconButton(
          icon: const Icon(Icons.location_on),
          tooltip: 'All User Addresses',
          onPressed: () => _goToUserAddresses(context),
        ),
      ],
    );
  }
}
