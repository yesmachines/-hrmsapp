import 'package:flutter/cupertino.dart';

class PersonalInfoField {
  const PersonalInfoField({
    required this.label,
    required this.value,
    required this.icon,
    this.isChip = false,
  });

  final String label;
  final String value;
  final IconData icon;
  final bool isChip;
}