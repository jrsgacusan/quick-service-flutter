import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:justino_components/justino_components.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:quick_service_clone/services/auth_service.dart';
import 'package:quick_service_clone/shared/constants.dart';
import 'file:///D:/Repositories/Repository-Flutter/quick_service_clone/lib/shared/widgets/loading_widget.dart';
import 'package:quick_service_clone/shared/widgets/button_widget.dart';

class InitialScreen extends StatefulWidget {
  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  final _formKey = GlobalKey<FormState>();

  //states to be monitored
  String email;
  String password;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: LoaderOverlay(
        child: SafeArea(
          child: Container(
            child: Form(
              //add form key here
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  //Logo
                  Image.asset(
                    'assets/logo.png',
                    width: 100,
                    height: 100,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //Email
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: TextFormField(
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                        validator: (val) => !EmailValidator.validate(val)
                            ? 'Invalid email'
                            : null,
                        decoration: textInputDecoration.copyWith(
                          hintText: 'Email',
                          prefixIcon: Icon(
                            Icons.email,
                          ),
                        )),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //password
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: TextFormField(
                      onChanged: (val) {
                        setState(() {
                          password = val;
                        });
                      },
                      validator: (val) => val.isEmpty ? 'Enter password' : null,
                      obscureText: true,
                      decoration: textInputDecoration.copyWith(
                          hintText: 'Password', prefixIcon: Icon(Icons.lock)),
                    ),
                  ),
                  SizedBox(
                    height: 0,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        //Register
                        TextButton(
                          child: Text(
                            'Register',
                            style: TextStyle(color: Colors.grey),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                                context, '/registration_screen');
                          },
                        ),
                        TextButton(
                          child: Text(
                            'Forgot password',
                            style: TextStyle(color: Colors.grey),
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 0,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: RaisedGradientButton(
                        child: Text(
                          'Sign in',
                          style: TextStyle(color: Colors.white),
                        ),
                        gradient: LinearGradient(
                          colors: <Color>[Colors.tealAccent[400], Colors.teal],
                        ),
                        onPressed: () async {
                          print('button clicked');
                          if (_formKey.currentState.validate()) {
                            context.loaderOverlay.show();
                            dynamic result = await AuthService()
                                .signInWithEmailAndPassword(email, password);
                            context.loaderOverlay.hide();
                            if (result is FirebaseAuthException) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('${result.message.toString()}'),
                                      action: SnackBarAction(
                                        label: 'Okay',
                                        onPressed: () {
                                          // Some code to undo the change.
                                        },
                                      )));
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                      content: Text('$result'),
                                      action: SnackBarAction(
                                        label: '',
                                        onPressed: () {
                                          // Some code to undo the change.
                                        },
                                      )));
                              //display also
                            }
                          }
                        }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
