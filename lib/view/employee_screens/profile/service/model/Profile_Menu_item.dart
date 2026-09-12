import 'package:flutter/cupertino.dart';

class ProfileMenuItem {
  const ProfileMenuItem({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
  });

  final String title;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
}