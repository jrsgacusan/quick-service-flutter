import 'package:flutter/material.dart';

class HintWidget extends StatelessWidget {
  final String text;
  final String title;
  VoidCallback callback;

  HintWidget({this.text, this.title, this.callback});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.all(16),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            text,
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 20, letterSpacing: 2),
          ),
          SizedBox(
            height: 8,
          ),
          FlatButton(
            minWidth: double.infinity,
            color: Colors.grey[100],
            onPressed: callback,
            child: Text('Hide'),
          ),
        ],
      ),
    );
  }
}
