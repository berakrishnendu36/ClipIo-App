import 'dart:async';

import 'package:clipio/screens/splash_screen.dart';
import 'package:clipio/theme/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CopyScreen extends StatefulWidget {
  @override
  _CopyScreenState createState() => _CopyScreenState();
}

class _CopyScreenState extends State<CopyScreen> {
  static const oneSecond = Duration(milliseconds: 1000);

  var _timeLeft = 5000;

  Timer _timer;
  bool _pressStayed = false;

  void initState() {
    super.initState();

    _timer = Timer.periodic(oneSecond, (Timer timer) {
      if (_timeLeft < 1000) {
        _timer.cancel();
        if (!_pressStayed) {
          SystemNavigator.pop();
        }
      } else {
        setState(() {
          _timeLeft -= 1000;
        });
      }
    });
  }

  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Copied to clipboard!",
              style: AppStyle.secondaryHeading,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Closing in ${_timeLeft ~/ 1000} secs",
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(
              width: double.infinity,
              height: 40,
            ),
            SizedBox(
              width: 245,
              child: TextButton(
                onPressed: () async {
                  setState(() {
                    _pressStayed = true;
                  });
                  _timer.cancel();
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => SplashScreen()));
                },
                child: Text(
                  "STAY",
                  style: AppStyle.buttonTextStyle,
                ),
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.all(10.0)),
                    backgroundColor: MaterialStateProperty.all(
                        AppStyle.buttonBackgroundColor)),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 20,
            ),
            SizedBox(
              width: 245,
              child: TextButton(
                onPressed: () async {
                  _timer.cancel();
                  setState(() {
                    _pressStayed = true;
                  });
                  SystemNavigator.pop();
                },
                child: Text(
                  "CLOSE",
                  style: AppStyle.buttonTextStyle,
                ),
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.all(10.0)),
                    backgroundColor: MaterialStateProperty.all(
                        AppStyle.buttonBackgroundColor)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
