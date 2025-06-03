import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size;
  
  const AppLogo({
    super.key,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/icon/splash_icon.png',
      width: size,
      height: size,
    );
  }
}