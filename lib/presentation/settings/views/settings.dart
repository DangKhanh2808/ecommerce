import 'package:ecommerce/common/bloc/button/button_state.dart';
import 'package:ecommerce/common/bloc/button/button_state_cubit.dart';
import 'package:ecommerce/common/helper/navigator/app_navigator.dart';
import 'package:ecommerce/common/widgets/appbar/app_bar.dart';
import 'package:ecommerce/presentation/auth/user/views/signin.dart';
import 'package:ecommerce/presentation/settings/widgets/add_product_tile.dart';
import 'package:ecommerce/presentation/settings/widgets/my_favorite_tile.dart';
import 'package:ecommerce/presentation/settings/widgets/my_order_tile.dart';
import 'package:ecommerce/presentation/settings/widgets/signout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppbar(
        title: Text('Settings'),
      ),
      body: BlocProvider(
        create: (context) => ButtonStateCubit(),
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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const MyFavortiesTile(),
                const SizedBox(
                  height: 15,
                ),
                const MyOrdersTile(),
                const SizedBox(
                  height: 15,
                ),
                SignOutButton(),
                const SizedBox(
                  height: 15,
                ),
                const AddProductTile(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
