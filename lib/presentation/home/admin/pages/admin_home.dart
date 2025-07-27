import 'package:ecommerce/common/bloc/product/product_display_cubit.dart';
import 'package:ecommerce/data/product/repository/product.dart';
import 'package:ecommerce/domain/product/repository/product.dart';
import 'package:ecommerce/domain/product/usecases/get_new_in.dart';
import 'package:ecommerce/presentation/home/widgets/categories.dart';
import 'package:ecommerce/presentation/home/widgets/header.dart';
import 'package:ecommerce/presentation/home/widgets/search_field.dart';
import 'package:ecommerce/presentation/product/bloc/deleteProduct/product_delete_cubit.dart';
import 'package:ecommerce/presentation/product/page/product_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/service_locator.dart';
import 'package:ecommerce/presentation/home/admin/pages/admin_user_management.dart';
import 'package:ecommerce/presentation/home/admin/pages/admin_user_list.dart';
import 'package:ecommerce/presentation/home/admin/pages/admin_all_user_addresses.dart';
import 'package:ecommerce/domain/auth/repository/user_repository.dart';
import 'package:ecommerce/data/auth/repository/user_repository_impl.dart';
import 'package:ecommerce/domain/auth/usecases/get_all_users.dart';
import 'package:ecommerce/domain/auth/usecases/update_user_address.dart';
import 'package:ecommerce/domain/auth/usecases/update_user_payment_method.dart';
import 'package:provider/provider.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<ProductRepository>(
      create: (_) => ProductRepositoryImpl(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                ProductDeleteCubit(context.read<ProductRepository>()),
          ),
          BlocProvider(
            create: (context) => ProductsDisplayCubit(
              useCase: sl<GetNewInUseCase>(),
            )..displayProducts(),
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Admin Home'),
            actions: [
              IconButton(
                icon: const Icon(Icons.people),
                tooltip: 'User Management',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MultiRepositoryProvider(
                        providers: [
                          RepositoryProvider<UserRepository>(
                            create: (_) => UserRepositoryImpl(),
                          ),
                        ],
                        child: MultiProvider(
                          providers: [
                            Provider<GetAllUsersUseCase>(
                              create: (context) => GetAllUsersUseCase(context.read<UserRepository>()),
                            ),
                            Provider<UpdateUserAddressUseCase>(
                              create: (context) => UpdateUserAddressUseCase(context.read<UserRepository>()),
                            ),
                            Provider<UpdateUserPaymentMethodUseCase>(
                              create: (context) => UpdateUserPaymentMethodUseCase(context.read<UserRepository>()),
                            ),
                          ],
                          child: const AdminUserListPage(),
                        ),
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.location_on),
                tooltip: 'All User Addresses',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MultiRepositoryProvider(
                        providers: [
                          RepositoryProvider<UserRepository>(
                            create: (_) => UserRepositoryImpl(),
                          ),
                        ],
                        child: MultiProvider(
                          providers: [
                            Provider<GetAllUsersUseCase>(
                              create: (context) => GetAllUsersUseCase(context.read<UserRepository>()),
                            ),
                            Provider<UpdateUserAddressUseCase>(
                              create: (context) => UpdateUserAddressUseCase(context.read<UserRepository>()),
                            ),
                            Provider<UpdateUserPaymentMethodUseCase>(
                              create: (context) => UpdateUserPaymentMethodUseCase(context.read<UserRepository>()),
                            ),
                          ],
                          child: const AdminAllUserAddressesPage(),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const Header(),
                const SizedBox(height: 24),
                const SearchField(),
                const SizedBox(height: 24),
                const Categories(),
                const SizedBox(
                  height: 600,
                  child: ProductListPage(), // ✅ Không cần Provider nữa
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
