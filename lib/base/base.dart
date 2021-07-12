import 'package:clipio/screens/clipedit.dart';
import 'package:clipio/store/clipstore.dart';
import 'package:clipio/theme/style.dart';
import 'package:clipio/utils/socket_controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

abstract class BaseViewModel<T extends StatefulWidget> extends State<T> {
  ClipStore clipStore = Get.find<ClipStore>();

  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  Future<bool> setClipboard(String text) async {
    // ClipboardData _curr = await Clipboard.getData(Clipboard.kTextPlain);
    // if (_curr.text == text) {
    //   return false;
    // }
    ClipboardData _data = ClipboardData(text: text);
    await Clipboard.setData(_data);
    return true;
  }

  Future<bool> getClipboard() async {
    ClipboardData _data = await Clipboard.getData(Clipboard.kTextPlain);
    // if (SocketController.clipController.text == _data.text) {
    //   return false;
    // }
    setState(() {
      SocketController.clipController.text = _data.text;
    });
    SocketController().emitClip(_data.text);
    return true;
  }

  Future<bool> insertItem(int index) async {
    if (SocketController.clipController.text != "") {
      bool _res =
          await clipStore.addCache(SocketController.clipController.text);
      if (_res) {
        listKey.currentState.insertItem(index);
      }
      return _res;
    }
    return false;
  }

  Future<void> removeCache(int index) async {
    String _text = clipStore.cacheList[index];
    String _title = clipStore.titleList[index];
    listKey.currentState.removeItem(
      index,
      (context, animation) => cacheListItem(_text, _title, index, animation),
    );
    await clipStore.deleteCache(index);
  }

  Widget cacheListItem(
      String text, String title, int index, Animation animation) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(animation),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -0.3),
          end: Offset(0, 0),
        ).animate(animation),
        child: Padding(
          padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
          child: Container(
            height: 55,
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: AppStyle.cacheBackgroundColor,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    title != ""
                        ? title
                        : text.substring(
                            0, 25 < text.length ? 25 : text.length),
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 40,
                  child: TextButton(
                    onPressed: () async {
                      bool _success = await setClipboard(text);
                      if (_success) {
                        showSuccessToast("Copied to clipboard!", 1000);
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          AppStyle.buttonBackgroundColor),
                    ),
                    child: Icon(
                      Icons.copy_all,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 40,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ClipEdit(
                                text: text,
                                index: index,
                                title: clipStore.titleList[index],
                              )));
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          AppStyle.buttonBackgroundColor),
                    ),
                    child: Icon(
                      Icons.edit,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 40,
                  child: TextButton(
                    onPressed: () async {
                      await removeCache(index);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          AppStyle.buttonBackgroundColor),
                    ),
                    child: Icon(
                      Icons.delete,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showErrorToast(String text, int duration) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: Duration(milliseconds: duration),
      behavior: SnackBarBehavior.fixed,
      content: Container(
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: AppStyle.errorToastBackgroundColor,
            borderRadius: BorderRadius.circular(40)),
        child: Text(
          text,
          style: AppStyle.toastTextStyle,
        ),
      ),
      backgroundColor: Colors.transparent,
    ));
  }

  void showSuccessToast(String text, int duration) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: Duration(milliseconds: duration),
      behavior: SnackBarBehavior.fixed,
      content: Container(
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: AppStyle.successToastBackgroundColor,
            borderRadius: BorderRadius.circular(40)),
        child: Text(
          text,
          style: AppStyle.toastTextStyle,
        ),
      ),
      backgroundColor: Colors.transparent,
    ));
  }
}
