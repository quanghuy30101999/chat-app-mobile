import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Welcome back",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 10),
        Text(
          "Login to your account",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 60),
      ],
    );
  }
}
