import 'package:flutter/material.dart';

class OptionWidget extends StatelessWidget {
  String optionsLabel;
  VoidCallback onPressed;
  IconData icon;

  OptionWidget({this.optionsLabel, this.onPressed, this.icon});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 2,
      child: Container(
        width: 100,
        height: 100,
        child: InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                size: 50,
                color: Colors.grey[600],
              ),
              SizedBox(
                width: 18,
              ),
              Text(
                optionsLabel,
                style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    fontSize: 18),
              )
            ],
          ),
          onTap: onPressed,
        ),
      ),
    );
  }
}
