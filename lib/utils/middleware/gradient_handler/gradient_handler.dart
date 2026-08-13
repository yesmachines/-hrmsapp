import 'package:flutter/material.dart';

class GradientHandler extends StatelessWidget {
  const GradientHandler({super.key,required this.gradient, required this.child,});

  final LinearGradient gradient;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (bounds) => gradient.createShader(
          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
        ),
        child: child);
  }
}
