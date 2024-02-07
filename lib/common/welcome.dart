import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Text(
      "Moin! 👋",
      style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
    ));
  }
}
