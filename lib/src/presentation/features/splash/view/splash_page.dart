import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // backgroundColor: context.color.onPrimary,
      body: Center(child: FlutterLogo(size: 210)),
    );
  }
}
