import 'package:flutter/material.dart';
import 'package:flutter_task/core/utils/assets_path/assets.gen.dart';
import 'package:flutter_task/features/academy/presentation/screens/academy_screen.dart';
import 'package:flutter_task/features/home/presentation/screens/home_screen.dart';
import 'package:flutter_task/features/pasar/presentation/screens/pasar_screen.dart';
import 'package:flutter_task/features/profile/presentation/screens/profile_screen.dart';
import 'package:flutter_task/features/signals/presentation/screens/signals_screen.dart';

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
      screen: const HomeScreen(),
    ),
    NavItemModel(
      icon: Assets.icons.fire.path,
      label: 'Signals',
      screen: const SignalsScreen(),
    ),
    NavItemModel(
      icon: Assets.icons.line.path,
      label: 'Tracking',
      screen: const PasarScreen(),
    ),
    NavItemModel(
      icon: Assets.icons.academy.path,
      label: 'Academy',
      screen: const AcademyScreen(),
    ),
    NavItemModel(
      icon: Assets.icons.profile.path,
      label: 'Profile',
      screen: const ProfileScreen(),
    ),
  ];
}
