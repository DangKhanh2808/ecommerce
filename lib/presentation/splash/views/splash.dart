import 'package:ecommerce/common/helper/navigator/app_navigator.dart';
import 'package:ecommerce/core/configs/assets/app_vector.dart';
import 'package:ecommerce/core/configs/theme/app_colors.dart';
import 'package:ecommerce/presentation/auth/user/views/signin.dart';
import 'package:ecommerce/presentation/home/admin/pages/admin_home.dart';
import 'package:ecommerce/presentation/home/user/pages/home.dart';
import 'package:ecommerce/presentation/splash/bloc/splash_cubit.dart';
import 'package:ecommerce/presentation/splash/bloc/splash_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SlashPage extends StatelessWidget {
  const SlashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is UnAuthenticatedState) {
          AppNavigator.pushReplacement(
            context,
            SigninPage(),
          );
        }

        if (state is AuthenticatedState) {
          if (state.role == 'user') {
            AppNavigator.pushReplacement(
              context,
              const HomePage(),
            );
          } else {
            AppNavigator.pushReplacement(
              context,
              const AdminHomePage(),
            );
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Center(
          child: SvgPicture.asset(AppVectors.appLogo),
        ),
      ),
    );
  }
}
