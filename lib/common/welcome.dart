import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Moin!  ",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        Image.asset(
          'assets/images/waving_hand.png',
          width: 40,
          height: 40,
        )
      ],
    ));
  }
}
