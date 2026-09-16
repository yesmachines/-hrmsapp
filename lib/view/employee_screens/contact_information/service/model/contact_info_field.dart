import 'package:flutter/cupertino.dart';

class ContactInfoField {
  const ContactInfoField({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;
}