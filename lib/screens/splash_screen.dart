import 'dart:async';
import 'package:clipio/screens/main_screen.dart';
import 'package:clipio/utils/shared_prefs.dart';

import 'package:clipio/screens/home_screen.dart';
import 'package:clipio/theme/style.dart';
import 'package:clipio/utils/socket_controller.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Duration _end = Duration(milliseconds: 1500);
  Duration _animationDuration = Duration(milliseconds: 1000);
  Animation curve;

  @override
  void initState() {
    super.initState();
    if (SharedPrefs().uid != "") {
      SocketController().init();
    }
    _animationController =
        AnimationController(vsync: this, duration: _animationDuration);
    curve = Tween<double>(begin: 0.0, end: 250.0).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeInOutBack));
    _animationController.addListener(() {
      setState(() {});
    });
    _animationController.forward();
    Timer(_end, () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  SharedPrefs().uid == "" ? HomeScreen() : MainScreen()));
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            child: Image.asset(
              "assets/images/clipio.png",
              width: curve.value,
              height: curve.value,
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _animationController,
              child: Text(
                "ClipIo",
                textAlign: TextAlign.center,
                style: AppStyle.headingStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
