import 'package:clipio/utils/shared_prefs.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketController {
  static IO.Socket _socket;

  static bool _socketConnected = false;

  static bool _notifyInProgress = false;

  @observable
  static TextEditingController clipController;

  static FirebaseMessaging _messaging;

  Map<String, String> user;

  factory SocketController() => SocketController._internal();

  SocketController._internal();

  bool get socketConnected => _socketConnected;

  void changeSocketConnection(bool val) {
    _socketConnected = val;
  }

  void init() async {
    print("init called");
    user = {"uid": SharedPrefs().uid};
    _socket = IO.io(
      'https://clipio-backend.azurewebsites.net',
      //'http://10.0.2.2:5000',
      //'http://localhost:5000',
      <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
      },
    );
    _socket.connect();
    _socket.onConnect((data) async {
      print('Socket connected');
      await Future.delayed(Duration(milliseconds: 500));
      changeSocketConnection(true);
      _socket.emit("join", user);
      startService();
    });
    clipController = new TextEditingController();
  }

  void registerNotification() async {
    // 2. Instantiate Firebase Messaging
    _messaging = FirebaseMessaging.instance;

    // 3. On iOS, this helps to take the user permissions
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      //print('User granted permission');
      String token = await _messaging.getToken();
      //print("FirebaseMessaging token: $token");
      SharedPrefs().token = token;
      _socket.emit("AddToken", {"uid": SharedPrefs().uid, "token": token});
    } else {
      print('User declined or has not accepted permission');
    }
  }

  removeToken() {
    _socket.emit("RemoveToken",
        {"uid": SharedPrefs().uid, "token": SharedPrefs().token});
  }

  notifyUsers() {
    if (_notifyInProgress == false) {
      _notifyInProgress = true;
      _socket.emit(
          "Notify", {"uid": SharedPrefs().uid, "clip": clipController.text});
    }
  }

  @action
  startService() {
    _socket.on("ClipChangeByServer", (data) {
      clipController.text = data;
      clipController.selection = TextSelection.fromPosition(
          TextPosition(offset: clipController.text.length));
    });

    _socket.on("newConnection", (data) async {
      await Future.delayed(Duration(milliseconds: 200));
      emitClip(clipController.text);
    });

    _socket.on("NotificationSent", (data) {
      _notifyInProgress = false;
    });

    _socket.on("NotificationNotSent", (data) {
      _notifyInProgress = false;
    });

    _socket.onConnect((data) async {
      print('Socket connected');
      await Future.delayed(Duration(milliseconds: 500));
      changeSocketConnection(true);
      _socket.emit("join", user);
      startService();
    });

    _socket.onDisconnect((data) {
      changeSocketConnection(false);
    });
  }

  void close() {
    _socket.off("ClipChangeByServer");
    _socket.off("newConnection");
    _socket.disconnect();
  }

  emitClip(String val) {
    _socket
        .emit("ClipChangeByClient", {"data": val, "room": SharedPrefs().uid});
  }
}
