import 'package:flutter/material.dart';
import 'package:flutter_task/core/utils/assets_path/assets.gen.dart';
import 'package:flutter_task/features/home/presentation/screens/home_screen.dart';
import 'package:flutter_task/features/profile/presentation/screens/profile_screen.dart';

class NavItemModel {
  final String icon;
  final String? activeIcon;
  final String? label;
  final Widget screen;

  const NavItemModel({
    required this.icon,
     this.activeIcon,
     this.label,
    required this.screen,
  });





  static List<NavItemModel> get userNavItems => [
    NavItemModel(
      icon: Assets.icons.home.path,
      label: 'Home',
      screen: HomeScreen(),
    ),

    NavItemModel(
      icon: Assets.icons.fire.path,
      label: 'Trending',
      screen: const Text(''),
    ),
    NavItemModel(
      icon: Assets.icons.add.path,
      label: 'Top Up',
      screen: const Center(),
    ),
    NavItemModel(
      icon: Assets.icons.line.path,
      label: 'Pasar',
      screen: const Center(),
    ),

    NavItemModel(
      icon: Assets.icons.profile.path,
      label: 'Profile',
      screen: const ProfileScreen(),
    ),
  ];
}
