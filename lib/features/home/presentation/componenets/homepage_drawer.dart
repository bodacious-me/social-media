import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:social_media_app/features/home/presentation/componenets/drawer_tile.dart';
import 'package:social_media_app/features/profile/presentation/pages/profile_page.dart';

class HomepageDrawer extends StatelessWidget {
  const HomepageDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50.0),
                child: Icon(
                  Icons.person,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Divider(
                color: Theme.of(context).colorScheme.primary,
              ),
              DrawerTile(
                  icon: Icons.home,
                  onTap: () => Navigator.of(context).pop(),
                  title: 'Home'),
              DrawerTile(
                  icon: Icons.person,
                  onTap: () {
                    Navigator.of(context).pop();
                    final user = context.read<AuthCubit>().currentUser;
                    //
                    String email = user!.email;
                    //
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfilePage(email: email
                            )));
                  },
                  title: 'Profile'),
              DrawerTile(icon: Icons.settings, onTap: () {}, title: 'Settings'),
              DrawerTile(icon: Icons.search, onTap: () {}, title: 'Search'),
              const Spacer(),
              DrawerTile(
                  icon: Icons.login,
                  onTap: () {
                    context.read<AuthCubit>().logout();
                  },
                  title: 'Logout'),
            ],
          ),
        ),
      ),
    );
  }
}
