import 'package:ecommerce/common/bloc/button/button_state.dart';
import 'package:ecommerce/common/bloc/button/button_state_cubit.dart';
import 'package:ecommerce/common/bloc/product/product_display_cubit.dart';
import 'package:ecommerce/common/helper/navigator/app_navigator.dart';
import 'package:ecommerce/common/widgets/appbar/app_bar.dart';
import 'package:ecommerce/common/widgets/responsive_container.dart';
import 'package:ecommerce/common/widgets/theme_switch.dart';
import 'package:ecommerce/domain/product/usecases/get_new_in.dart';
import 'package:ecommerce/presentation/auth/user/views/signin.dart';
import 'package:ecommerce/presentation/settings/widgets/my_favorite_tile.dart';
import 'package:ecommerce/presentation/settings/widgets/my_order_tile.dart';
import 'package:ecommerce/presentation/settings/widgets/signout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/service_locator.dart';
import 'package:ecommerce/presentation/settings/views/address_list_page.dart';
import 'package:ecommerce/presentation/settings/views/payment_method_list_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    return Scaffold(
      appBar: const BasicAppbar(
        title: Text('Settings'),
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ButtonStateCubit(),
          ),
          BlocProvider(
            create: (context) =>
                ProductsDisplayCubit(useCase: sl<GetNewInUseCase>())
                  ..displayProducts(),
          ),
        ],
        child: BlocListener<ButtonStateCubit, ButtonState>(
          listener: (context, state) {
            if (state is ButtonFailureState) {
              var snackbar = SnackBar(
                content: Text(state.errorMessage),
                behavior: SnackBarBehavior.floating,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
            }

            if (state is ButtonSuccessState) {
              AppNavigator.pushAndRemove(context, SigninPage());
            }
          },
          child: ResponsiveContainer(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Preferences',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                const ThemeSwitch(),
                const SizedBox(height: 32),
                Text(
                  'Account',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                const MyFavortiesTile(),
                const SizedBox(height: 12),
                const MyOrdersTile(),
                const SizedBox(height: 12),
                // Bổ sung quản lý địa chỉ giao hàng
                ListTile(
                  leading: const Icon(Icons.location_on_outlined),
                  title: const Text('Quản lý địa chỉ giao hàng'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddressListPage(userId: userId),
                      ),
                    );
                  },
                ),
                // Bổ sung quản lý phương thức thanh toán
                ListTile(
                  leading: const Icon(Icons.credit_card_outlined),
                  title: const Text('Quản lý phương thức thanh toán'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PaymentMethodListPage(userId: userId),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                SignOutButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
