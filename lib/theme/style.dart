import 'package:flutter/material.dart';

class AppStyle {
  static const backgroundColor = Color(0xff100e16);
  static const primaryColor = const Color(0xff0a1f33);
  static const buttonBackgroundColor = Color(0xff413c56);
  static const cacheBackgroundColor = Color(0xff686478);
  static const errorToastBackgroundColor = Colors.red;
  static const successToastBackgroundColor = Colors.green;
  static const bottomNavBackgroundColor = Color(0xff4e4c57);

  static const textBoxTextColor = Colors.white;

  static const headingStyle = TextStyle(
      fontSize: 35,
      color: Colors.white,
      fontWeight: FontWeight.w200,
      letterSpacing: 3,
      decoration: TextDecoration.none);

  static const subHeadingStye = TextStyle(
      fontSize: 20,
      color: Colors.white,
      fontWeight: FontWeight.w300,
      letterSpacing: 2.5,
      decoration: TextDecoration.none);

  static const secondaryHeading = TextStyle(
      fontSize: 25,
      color: Colors.white,
      fontWeight: FontWeight.w500,
      letterSpacing: 2,
      decoration: TextDecoration.none);

  static const buttonTextStyle = TextStyle(
      fontSize: 14,
      color: Colors.white,
      fontWeight: FontWeight.w400,
      letterSpacing: 2.5,
      decoration: TextDecoration.none);

  static var toastTextStyle = const TextStyle(
      color: AppStyle.backgroundColor,
      fontSize: 16,
      fontWeight: FontWeight.bold);

  static var textBoxTextStyle =
      const TextStyle(fontSize: 18, color: Colors.white);
}
