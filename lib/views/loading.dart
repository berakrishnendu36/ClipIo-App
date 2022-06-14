import 'package:clipio/theme/style.dart';
import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  final String text;
  Loading(this.text);
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 45,
            height: 45,
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
              strokeWidth: 2.5,
              color: Colors.grey,
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 20,
          ),
          Text(
            widget.text,
            style: AppStyle.subHeadingStye,
          )
        ],
      ),
    );
  }
}
