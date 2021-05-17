import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_service_clone/models/user_data.dart';
import 'package:quick_service_clone/screens/authenticate/initial_screen.dart';
import 'package:quick_service_clone/services/database_service.dart';
import 'package:quick_service_clone/screens/authenticated/choose_mode_screen.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    if (user == null) {
      return InitialScreen();
    } else {
      if (user.emailVerified) {
        return StreamProvider<UserData>.value(
            value: DatabaseService(uid: user.uid).myData,
            child: ChooseModeScreen());
      } else {
        return InitialScreen();
      }
    }
  }
}
