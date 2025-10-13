import 'package:ecommerce/common/helper/navigator/app_navigator.dart';
import 'package:ecommerce/core/configs/assets/app_images.dart';
import 'package:ecommerce/core/configs/assets/app_vector.dart';
import 'package:ecommerce/core/configs/theme/app_colors.dart';
import 'package:ecommerce/domain/auth/entity/user.dart';
import 'package:ecommerce/presentation/cart/views/cart.dart';
import 'package:ecommerce/presentation/home/user/bloc/user_infor_display_cubit.dart';
import 'package:ecommerce/presentation/home/user/bloc/user_infor_display_state.dart';
import 'package:ecommerce/presentation/cart/bloc/cart_products_display_cubit.dart';
import 'package:ecommerce/presentation/cart/bloc/cart_products_display_state.dart';
import 'package:ecommerce/presentation/settings/views/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ecommerce/core/constants/app_strings.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => UserInforDisplayCubit()..displayUserInfor()),
        BlocProvider(
            create: (context) =>
                CartProductsDisplayCubit()..displayCartProduct()),
      ],
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(
          top: 40,
          right: 16,
          left: 16,
          bottom: 16,
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
        child: BlocBuilder<UserInforDisplayCubit, UserInforDisplayState>(
          builder: (context, state) {
            if (state is UserInforLoaded) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _profileImage(state.user, context),
                      _gender(state.user),
                      _card(context),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppStrings.welcomeBack,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    state.user.firstName.isNotEmpty
                        ? state.user.firstName
                        : AppStrings.user,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            }

            // Show placeholder instead of loading indicator
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _profileImagePlaceholder(),
                    _genderPlaceholder(),
                    _card(context),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  AppStrings.welcomeBack,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  height: 24,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _profileImagePlaceholder() {
    return Container(
      height: 48,
      width: 48,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
      ),
    );
  }

  Widget _genderPlaceholder() {
    return Container(
      height: 40,
      width: 80,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
    );
  }

  Widget _profileImage(UserEntity user, BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppNavigator.push(context, SettingsPage());
      },
      child: Container(
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: user.image.isNotEmpty
                ? NetworkImage(user.image) as ImageProvider
                : const AssetImage(AppImages.profile),
            fit: BoxFit.cover,
          ),
          color: Colors.grey[300],
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gender(UserEntity user) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          user.gender == 1 ? AppStrings.men : AppStrings.women,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _card(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppNavigator.push(context, const CartPage());
      },
      child: SizedBox(
        height: 48,
        width: 48,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Center(
                child: SvgPicture.asset(
                  AppVectors.bag,
                  height: 20,
                  width: 20,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: BlocBuilder<CartProductsDisplayCubit,
                  CartProductsDisplayState>(
                builder: (context, state) {
                  int count = 0;
                  if (state is CartProductsLoaded) {
                    count = state.products
                        .fold(0, (sum, p) => sum + p.productQuantity);
                  }
                  if (count == 0) return const SizedBox.shrink();
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    constraints:
                        const BoxConstraints(minWidth: 18, minHeight: 18),
                    child: Text(
                      count > 99 ? '99+' : '$count',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
