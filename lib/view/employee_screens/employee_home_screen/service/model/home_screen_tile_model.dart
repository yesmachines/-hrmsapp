import 'package:flutter/material.dart';

class HomeScreenTileModel {
  const HomeScreenTileModel({
    required this.title,
    required this.lines,
    required this.icon,
    required this.startColor,
    required this.endColor,
    this.progress,
  });

  final String title;
  final List<String> lines;
  final IconData icon;
  final Color startColor;
  final Color endColor;
  final double? progress;
}
