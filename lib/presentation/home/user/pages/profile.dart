import 'package:ecommerce/core/configs/theme/bloc/theme_cubit.dart';
import 'package:ecommerce/presentation/auth/user/views/signin.dart';
import 'package:ecommerce/presentation/settings/views/my_favorites.dart';
import 'package:ecommerce/presentation/settings/views/my_orders.dart';
import 'package:ecommerce/presentation/settings/views/profile_management.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/presentation/home/user/bloc/profile_cubit.dart';
import 'package:ecommerce/presentation/home/user/bloc/profile_state.dart';
import 'package:ecommerce/service_locator.dart';
import 'package:ecommerce/domain/auth/usecases/signout.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ProfileCubit(authRepository: context.read())..loadProfile(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Account'),
          centerTitle: true,
        ),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is ProfileLoaded) {
              final user = state.user;

              return Column(
                children: [
                  // Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 119, 188, 199),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(
                            user.image.isNotEmpty
                                ? user.image
                                : 'https://static.vecteezy.com/system/resources/previews/027/247/050/original/persian-cat-isolated-on-transparent-background-ai-generated-png.png',
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${user.firstName} ${user.lastName}',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.email,
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Options
                  Expanded(
                    child: ListView(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.favorite),
                          title: const Text('My Favorites'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const MyFavoritesPage()),
                            );
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.shopping_bag),
                          title: const Text('My Orders'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const MyOrdersPage()),
                            );
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.manage_accounts),
                          title: const Text('Profile Management'),
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileManagementPage(
                                  user: user,
                                  onProfileUpdated: () {
                                    context.read<ProfileCubit>().loadProfile();
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.brightness_6),
                          title: const Text('Theme (Dark / Light)'),
                          onTap: () {
                            context.read<ThemeCubit>().toggleTheme();
                          },
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.logout, color: Colors.red),
                          title: const Text('Logout',
                              style: TextStyle(color: Colors.red)),
                          onTap: () async {
                            await sl<SignoutUseCase>().call();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (_) => SigninPage()),
                              (route) => false,
                            );
                          },
                        ),
                      ],
                    ),
                  )
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
