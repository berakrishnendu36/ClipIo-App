import 'package:clipio/screens/main_screen.dart';
import 'package:clipio/theme/style.dart';
import 'package:clipio/utils/auth.dart';
import 'package:clipio/utils/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Authentication auth;
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "ClipIo",
                style: AppStyle.headingStyle,
              ),
              Padding(
                padding: EdgeInsets.only(top: 40.0, bottom: 40.0),
                child: Image.asset(
                  "assets/images/hero.png",
                  width: 300,
                  height: 300,
                ),
              ),
              Text(
                "A Universal clipboard for all your devices!",
                textAlign: TextAlign.center,
                style: AppStyle.subHeadingStye,
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
              ),
              Container(
                width: 280,
                child: TextButton(
                  onPressed: () async {
                    var user =
                        await Authentication.signInWithGoogle(context: context);
                    if (user.uid != null) {
                      SharedPrefs().uid = user.uid.toString();
                      SharedPrefs().name = user.displayName.toString();

                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MainScreen()));
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Icon(Icons.android),
                      ),
                      Text(
                        "SIGN IN WITH GOOGLE",
                        style: AppStyle.buttonTextStyle,
                      ),
                    ],
                  ),
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.all(10.0)),
                      backgroundColor: MaterialStateProperty.all(
                          AppStyle.buttonBackgroundColor)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
