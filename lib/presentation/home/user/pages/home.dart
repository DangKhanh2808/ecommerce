// lib/presentation/home/home_page.dart
import 'package:ecommerce/common/widgets/bottombar/bottom_bar.dart';
import 'package:ecommerce/common/widgets/responsive_container.dart';
import 'package:ecommerce/presentation/cart/views/cart.dart';
import 'package:ecommerce/presentation/home/user/pages/profile.dart';
import 'package:ecommerce/presentation/home/widgets/categories.dart';
import 'package:ecommerce/presentation/home/widgets/header.dart';
import 'package:ecommerce/presentation/home/widgets/new_in.dart';
import 'package:ecommerce/presentation/home/widgets/search_field.dart';
import 'package:ecommerce/presentation/home/widgets/top_selling.dart';
import 'package:ecommerce/presentation/home/widgets/all_product_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/presentation/settings/views/my_favorites.dart';
import 'package:ecommerce/core/constants/app_strings.dart';
import 'package:ecommerce/presentation/home/user/bloc/home_loading_cubit.dart';
import 'package:ecommerce/presentation/home/user/bloc/profile_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomeContent(),
      const AllProductsPage(),
      const CartPage(),
      const MyFavoritesPage(),
      BlocProvider(
        create: (_) => ProfileCubit(authRepository: context.read())..loadProfile(),
        child: const ProfilePage(),
      ),
    ];
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        showProduct: true, // Pass flag to show Product tab
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return BlocProvider(
      create: (context) => HomeLoadingCubit(),
      child: BlocBuilder<HomeLoadingCubit, HomeLoadingState>(
        builder: (context, state) {
          // Auto transition to loaded state after 2 seconds
          if (state is HomeLoading) {
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) {
                context.read<HomeLoadingCubit>().setLoaded();
              }
            });
            
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          
          if (state is HomeError) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error: ${state.message}',
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<HomeLoadingCubit>().setLoading();
                        // Retry loading
                        Future.delayed(const Duration(seconds: 2), () {
                          context.read<HomeLoadingCubit>().setLoaded();
                        });
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }
          
          return ResponsiveContainer(
            padding: EdgeInsets.zero,
            useSafeArea: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Header(),
                ResponsivePadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SearchField(),
                      const SizedBox(height: 24),
                      Text(
                        AppStrings.categories,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Categories(),
                      const SizedBox(height: 32),
                      const TopSelling(),
                      const SizedBox(height: 32),
                      const NewIn(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
