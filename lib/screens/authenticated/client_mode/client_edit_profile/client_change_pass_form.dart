import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:quick_service_clone/services/auth_service.dart';
import 'package:quick_service_clone/services/database_service.dart';
import 'package:quick_service_clone/shared/constants.dart';
import 'package:quick_service_clone/shared/widgets/button_widget.dart';
import 'package:quick_service_clone/shared/widgets/snackbar_widget.dart';

class ClientChangePassForm extends StatefulWidget {
  @override
  _ClientChangePassFormState createState() => _ClientChangePassFormState();
}

class _ClientChangePassFormState extends State<ClientChangePassForm> {
  final _formKey = GlobalKey<FormState>();
  String password;
  String retypePassword;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 16,
            ),
            Text(
              'Enter your new password',
              style: TextStyle(fontSize: 24, letterSpacing: 2),
            ),
            Divider(
              height: 32,
            ),
            TextFormField(
              obscureText: true,
              onChanged: (val) {
                setState(() {
                  password = val;
                });
              },
              validator: (val) {
                return val == null || val == ""
                    ? "Enter your new password."
                    : null;
              },
              decoration:
                  textInputDecoration.copyWith(hintText: 'New password'),
            ),
            SizedBox(
              height: 16,
            ),
            TextFormField(
              obscureText: true,
              onChanged: (val) {
                setState(() {
                  retypePassword = val;
                });
              },
              validator: (val) {
                return val != password ? "Password doesn't match." : null;
              },
              decoration:
                  textInputDecoration.copyWith(hintText: 'Retype new password'),
            ),
            SizedBox(
              height: 16,
            ),
            RaisedGradientButton(
                child: Text(
                  'Save',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                gradient: LinearGradient(
                  colors: <Color>[Colors.tealAccent[400], Colors.teal],
                ),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    dynamic response =
                        await AuthService().changePassword(password);
                    if (response is FirebaseAuthException) {
                      SnackbarWidget(
                              context: context,
                              onPressed: () {},
                              label: '',
                              text: "${response.message}")
                          .showSnackbar();
                      Navigator.pop(context);
                    } else {
                      SnackbarWidget(
                              context: context,
                              onPressed: () {},
                              label: '',
                              text: "Password successfully changed.")
                          .showSnackbar();
                      Navigator.pop(context);
                    }
                  }
                }),
            SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    ));
  }
}
