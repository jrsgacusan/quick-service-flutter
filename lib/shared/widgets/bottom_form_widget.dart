import 'package:flutter/material.dart';

class BottomFormWidget {
  Widget child;
  BuildContext context;

  BottomFormWidget({this.context, this.child});

  void showForm() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Wrap(
            children: [
              Container(child: child),
            ],
          );
        });
  }
}
