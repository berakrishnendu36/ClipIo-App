import 'dart:async';
import 'dart:ui';

import 'package:clipio/base/base.dart';
import 'package:clipio/screens/copy.dart';
import 'package:clipio/screens/home_screen.dart';
import 'package:clipio/theme/style.dart';
import 'package:clipio/utils/auth.dart';
import 'package:clipio/utils/shared_prefs.dart';
import 'package:clipio/utils/socket_controller.dart';
import 'package:clipio/views/loading.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends BaseViewModel<MainScreen>
    with SingleTickerProviderStateMixin {
  SocketController socket = new SocketController();
  Timer _timer;
  bool socketConnected = false;
  KeyboardVisibilityController _keyboardVisibilityController;
  bool _visible;
  FocusNode myFocusNode;

  AnimationController _animationController;
  Duration _animationDuration = Duration(milliseconds: 200);
  Animation _slideAnimation;
  Animation _fadeAnimation;

  void initState() {
    _visible = false;
    _animationController =
        AnimationController(vsync: this, duration: _animationDuration);

    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.2), end: Offset(0, 0))
        .animate(CurvedAnimation(
            parent: _animationController, curve: Curves.easeInOut));

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    myFocusNode = FocusNode();

    _keyboardVisibilityController = new KeyboardVisibilityController();

    _keyboardVisibilityController.onChange.listen((bool value) {
      if (value) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
      setState(() {
        _visible = value;
      });
    });
    if (!SocketController().socketConnected) {
      SocketController().init();
    } else {
      socketConnected = true;
      SocketController().registerNotification();
    }

    if (!socketConnected) {
      _timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
        if (SocketController().socketConnected) {
          if (!socketConnected) {
            setState(() {
              socketConnected = true;
            });
            SocketController().registerNotification();
          }
        } else {
          setState(() {
            socketConnected = false;
          });
        }
      });
    }

    SocketController.clipController.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  void dispose() {
    _timer.cancel();
    SocketController.clipController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print("Message received: ${message.data["clip"]}");
      ClipboardData _data = ClipboardData(text: message.data["clip"]);
      await Clipboard.setData(_data);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => CopyScreen()));
    });

    return GestureDetector(
      onTap: () {
        if (_visible) {
          myFocusNode.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () async {
                    //print(SharedPrefs().name);
                    SocketController().removeToken();
                    await Authentication.signOut(context: context);
                    SocketController().close();
                    SharedPrefs().uid = "";
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  },
                  child: Text(
                    "SIGN OUT",
                    style: AppStyle.buttonTextStyle,
                  ),
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.all(10.0)),
                      backgroundColor: MaterialStateProperty.all(
                          AppStyle.buttonBackgroundColor)),
                ),
                TextButton(
                  onPressed: () {
                    if (SocketController.clipController.text != "") {
                      SocketController().notifyUsers();
                    } else {
                      showErrorToast("TextField is empty", 1500);
                    }
                  },
                  child: Text(
                    "NOTIFY",
                    style: AppStyle.buttonTextStyle,
                  ),
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.all(10.0)),
                      backgroundColor: MaterialStateProperty.all(
                          AppStyle.buttonBackgroundColor)),
                ),
              ],
            ),
          ),
        ),
        body: !socketConnected
            ? Loading("Connecting to server..")
            : Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 15.0, bottom: 10.0),
                          child: Text(
                            "Hey, " + SharedPrefs().name.split(" ")[0],
                            style: AppStyle.secondaryHeading,
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, left: 16.0, right: 16.0, bottom: 8.0),
                            child: Container(
                              width: double.infinity,
                              height: 60,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: AppStyle.buttonBackgroundColor,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Row(children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _visible = true;
                                    });
                                    myFocusNode.requestFocus();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      SocketController.clipController.text !=
                                                  "" &&
                                              SocketController
                                                      .clipController.text !=
                                                  null
                                          ? SocketController.clipController.text
                                              .substring(
                                                  0,
                                                  SocketController
                                                              .clipController
                                                              .text
                                                              .length >
                                                          40
                                                      ? 40
                                                      : SocketController
                                                          .clipController
                                                          .text
                                                          .length)
                                          : "Paste/copy text from here",
                                      style: AppStyle.textBoxTextStyle,
                                    ),
                                  ),
                                ),
                                Expanded(child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _visible = true;
                                    });
                                    myFocusNode.requestFocus();
                                  },
                                )),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        SocketController.clipController.text =
                                            "";
                                      });
                                      SocketController().emitClip("");
                                    },
                                    icon: Icon(Icons.close))
                              ]),
                            )),
                        SizedBox(
                          width: 245,
                          child: TextButton(
                            onPressed: () async {
                              bool _success = await setClipboard(
                                  SocketController.clipController.text);
                              if (_success) {
                                showSuccessToast("Copied to clipboard!", 1000);
                              }
                            },
                            child: Text(
                              "COPY TO CLIPBOARD",
                              style: AppStyle.buttonTextStyle,
                            ),
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.all(10.0)),
                                backgroundColor: MaterialStateProperty.all(
                                    AppStyle.buttonBackgroundColor)),
                          ),
                        ),
                        SizedBox(
                          width: 245,
                          child: TextButton(
                            onPressed: () async {
                              bool _success = await insertItem(0);
                              if (!_success) {
                                showErrorToast("Error in adding cache!", 2000);
                              }
                            },
                            child: Text(
                              "ADD TO CACHE",
                              style: AppStyle.buttonTextStyle,
                            ),
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.all(10.0)),
                                backgroundColor: MaterialStateProperty.all(
                                    AppStyle.buttonBackgroundColor)),
                          ),
                        ),
                        SizedBox(
                          width: 245,
                          child: TextButton(
                            onPressed: () async {
                              bool _success = await getClipboard();
                              if (_success) {
                                showSuccessToast(
                                    "Pasted from clipboard!", 1000);
                              }
                            },
                            child: Text(
                              "PASTE FROM CLIPBOARD",
                              style: AppStyle.buttonTextStyle,
                            ),
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.all(10.0)),
                                backgroundColor: MaterialStateProperty.all(
                                    AppStyle.buttonBackgroundColor)),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: Text(
                            "Your Clip History",
                            style: AppStyle.subHeadingStye,
                          ),
                        ),
                        Expanded(
                            child: AnimatedList(
                                key: listKey,
                                initialItemCount: clipStore.cacheList.length,
                                itemBuilder: (context, index, animation) {
                                  return cacheListItem(
                                      clipStore.cacheList[index],
                                      clipStore.titleList[index],
                                      index,
                                      animation);
                                })),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: _visible,
                    child: Positioned.fill(
                      child: Center(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 10.0,
                            sigmaY: 10.0,
                          ),
                          child: Container(
                            color: Colors.black.withOpacity(0.2),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _visible,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 30.0, left: 16.0, right: 16.0, bottom: 8.0),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                                maxWidth: double.infinity, maxHeight: 240),
                            child: TextField(
                              autocorrect: false,
                              maxLines: null,
                              focusNode: myFocusNode,
                              controller: SocketController.clipController,
                              onChanged: (val) {
                                SocketController().emitClip(val);
                              },
                              cursorColor: Colors.white,
                              style: AppStyle.textBoxTextStyle,
                              decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    splashRadius: 1,
                                    onPressed: () {
                                      setState(() {
                                        SocketController.clipController.text =
                                            "";
                                      });
                                      SocketController().emitClip("");
                                    },
                                    icon: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none),
                                  hintText: "Paste/Copy text from here..",
                                  hintStyle: AppStyle.textBoxTextStyle,
                                  fillColor: AppStyle.buttonBackgroundColor,
                                  filled: true),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
