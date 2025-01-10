import 'package:ecommerce/core/configs/assets/app_vector.dart';
import 'package:ecommerce/core/configs/theme/app_colors.dart';
import 'package:ecommerce/presentation/auth/views/signin.dart';
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
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const SigninPage(),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Center(
          child: SvgPicture.asset(AppVector.appLogo),
        ),
      ),
    );
  }
}
