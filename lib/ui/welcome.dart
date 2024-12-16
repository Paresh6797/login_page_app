import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key, required this.username});
  final String username;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Welcome"),centerTitle: true,),
      body: Center(
        child: Text("Welcome $username", style: TextStyle(fontSize: 24)),
      ),
    );
  }
}