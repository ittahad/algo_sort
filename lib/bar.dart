import 'package:flutter/material.dart';

class Bar extends StatelessWidget {
  final double height;
  Bar({this.height = double.infinity});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 2.0,
        right: 2.0,
        top: 10.0,
      ),
      width: 10,
      height: height,
      color: Colors.deepOrange,
      child: RotatedBox(
        quarterTurns: 3,
        child: Text(
          height.toInt().toString(),
          style: TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
