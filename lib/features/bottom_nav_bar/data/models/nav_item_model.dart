import 'package:flutter/material.dart';
import 'package:flutter_task/core/utils/assets_path/assets.gen.dart';
import 'package:flutter_task/features/auth/presentation/login/log_in_screen.dart';

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

  static List<NavItemModel> get userNavItems => _navItems;





  // ─── Bottom Nav Items ──────────────────────────────────────────────────────
  static final List<NavItemModel> _navItems = [
    NavItemModel(
      icon: Assets.icons.home.path,
      screen: const LoginScreen(),
    ),
    NavItemModel(
      icon: Assets.icons.home.path,
      screen: const LoginScreen(),
    ),
    NavItemModel(
      icon: Assets.icons.profile.path,
      screen: const LoginScreen(),
    ),
  ];
}
