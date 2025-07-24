// lib/presentation/home/home_page.dart
import 'package:ecommerce/common/widgets/bottombar/bottom_bar.dart';
import 'package:ecommerce/presentation/cart/views/cart.dart';
import 'package:ecommerce/presentation/home/user/pages/profile.dart';
import 'package:ecommerce/presentation/home/widgets/categories.dart';
import 'package:ecommerce/presentation/home/widgets/header.dart';
import 'package:ecommerce/presentation/home/widgets/new_in.dart';
import 'package:ecommerce/presentation/home/widgets/search_field.dart';
import 'package:ecommerce/presentation/home/widgets/top_selling.dart';
import 'package:ecommerce/presentation/settings/views/my_favorites.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(),
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
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Header(),
          const SizedBox(height: 24),
          const SearchField(),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Categories(),
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: TopSelling(),
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: NewIn(),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
