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
import 'package:ecommerce/presentation/settings/views/my_favorites.dart';
import 'package:ecommerce/core/constants/app_strings.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(),
    const AllProductsPage(),
    const CartPage(),
    const MyFavoritesPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        showProduct: true, // Pass flag to show Product tab
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
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
  }
}
