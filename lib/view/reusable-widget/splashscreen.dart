import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Colors.indigo,
              Colors.indigo[200],
            ])),
        child: Center(
          child: Image.asset('assets/gif/loading_placeholder.gif'),
        ),
      ),
    );
  }
}
