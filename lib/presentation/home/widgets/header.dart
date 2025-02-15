import 'package:ecommerce/core/configs/assets/app_vector.dart';
import 'package:ecommerce/core/configs/theme/app_colors.dart';
import 'package:ecommerce/presentation/home/bloc/user_infor_display_cubit.dart';
import 'package:ecommerce/presentation/home/bloc/user_infor_display_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserInforDisplayCubit()..displayUserInfor(),
      child: BlocBuilder<UserInforDisplayCubit, UserInforDisplayState>(
        builder: (context, state) {
          if (state is UserInforLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is UserInforLoaded) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _profileImage(),
                _gender(),
                _card(),
              ],
            );
          }

          return Container();
        },
      ),
    );
  }

  Widget _profileImage() {
    return Container(
      height: 40,
      width: 40,
      decoration:
          const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
    );
  }

  Widget _gender() {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.secondBackground,
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }

  Widget _card() {
    return Container(
      height: 40,
      width: 40,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: SvgPicture.asset(
        AppVector.bag,
        fit: BoxFit.none,
      ),
    );
  }
}
