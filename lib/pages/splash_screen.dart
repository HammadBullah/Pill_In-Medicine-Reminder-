import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _animationComplete = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 6700), // Set the duration to match your animation
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _animationComplete = true;
          });
          navigateToHomeScreen();
        }
      });

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Material(
          color: const Color.fromARGB(255, 12, 113, 136),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, snapshot) {
              return FlareActor(
                'assests/animations/Liquid Download.flr',
                animation: 'Demo', // Replace with the animation name in your Flare file
                fit: BoxFit.contain,
              );
            },
          ),
        ),
      ),
    );
  }

  void navigateToHomeScreen() {
    if (_animationComplete) {
      // Perform any additional initialization tasks here if needed.
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
