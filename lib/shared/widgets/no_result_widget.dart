import 'package:flutter/material.dart';




class NoResultWidget extends StatelessWidget {
  final String imagePath;
  final String text;

  NoResultWidget({this.imagePath, this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ClipOval(
            child: Image.asset(
              imagePath,
              width: 150,
              height: 150,
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            text,
            style: TextStyle(letterSpacing: 2),
          )
        ],
      ),
    );
  }
}
