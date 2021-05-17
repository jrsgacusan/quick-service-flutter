import 'package:flutter/material.dart';


class SnackbarWidget {

  String text;
  Function onPressed;
  BuildContext context;
  String label ;

  SnackbarWidget({this.context, this.text, this.onPressed, this.label});


  void showSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(

        content: Text(text),
        action: SnackBarAction(
            label: label,
            onPressed: onPressed
        )));
  }


}




