import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:quick_service_clone/models/user_data.dart';
import 'package:quick_service_clone/services/auth_service.dart';
import 'package:quick_service_clone/shared/constants.dart';
import 'file:///D:/Repositories/Repository-Flutter/quick_service_clone/lib/shared/widgets/loading_widget.dart';
import 'package:quick_service_clone/shared/widgets/button_widget.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  //States
  String name, email, password, retypePassword;
  File image;
  int age, number;
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: SafeArea(
          child: Form(
            //add key here
            key: _formKey,
            child: ListView(
              children: <Widget>[
                Container(
                  height: 150.0,
                  color: Colors.transparent,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      _buildUpperBoxGradient(),
                      FractionalTranslation(
                          translation: Offset(0.0, 0.5), child: _buildImage()),
                    ],
                  ),
                ),
                SizedBox(
                  height: 80,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: TextFormField(
                      validator: (val) => val.isEmpty ? 'Enter password' : null,
                      onChanged: (val) {
                        setState(() {
                          name = val;
                        });
                      },
                      decoration: textInputDecoration.copyWith(
                        hintText: 'Name',
                        prefixIcon: Icon(
                          Icons.person,
                        ),
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: TextFormField(
                      validator: (val) => !EmailValidator.validate(val)
                          ? 'Invalid email'
                          : null,
                      onChanged: (val) {
                        setState(() {
                          email = val;
                        });
                      },
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: TextFormField(
                      validator: (val) =>
                          !(int.parse(val) >= 18 && int.parse(val) <= 75) ||
                                  val.isEmpty
                              ? 'Invalid age'
                              : null,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                      ],
                      onChanged: (val) {
                        setState(() {
                          age = int.parse(val);
                        });
                      },
                      decoration: textInputDecoration.copyWith(
                        hintText: 'Age',
                        prefixIcon: Icon(
                          Icons.info,
                        ),
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: TextFormField(
                      validator: (val) => val.length != 11 || val.isEmpty
                          ? 'Invalid phone number'
                          : null,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                      ],
                      onChanged: (val) {
                        setState(() {
                          number = int.parse(val);
                        });
                      },
                      decoration: textInputDecoration.copyWith(
                        hintText: 'Number',
                        prefixIcon: Icon(
                          Icons.phone,
                        ),
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: TextFormField(
                      validator: (val) =>
                          val.isEmpty ? 'Enter a password' : null,
                      obscureText: true,
                      onChanged: (val) {
                        setState(() {
                          password = val;
                        });
                      },
                      decoration: textInputDecoration.copyWith(
                        hintText: 'Password',
                        prefixIcon: Icon(
                          Icons.vpn_key,
                        ),
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: TextFormField(
                      validator: (val) =>
                          val != password ? 'Password does not match' : null,
                      obscureText: true,
                      onChanged: (val) {
                        setState(() {
                          retypePassword = val;
                        });
                      },
                      decoration: textInputDecoration.copyWith(
                        hintText: 'Re-type password',
                        prefixIcon: Icon(
                          Icons.vpn_key,
                        ),
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: RaisedGradientButton(
                      child: Text(
                        'Sign up',
                        style: TextStyle(color: Colors.white),
                      ),
                      gradient: LinearGradient(
                        colors: <Color>[Colors.tealAccent[400], Colors.teal],
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          context.loaderOverlay.show();
                          //Use the auth service
                          UserData userData = UserData.NewUser(
                              profileImageUrl: null,
                              name: name,
                              email: email,
                              age: age,
                              number: number);
                          dynamic result = await AuthService()
                              .registerWithEmailAndPassword(
                                  email, password, userData, image);

                          if (result is! User) {
                            context.loaderOverlay.hide();

                            //display a toast - unsuccessful message using the result
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('$result'),
                                action: SnackBarAction(
                                  label: 'Okay',
                                  onPressed: () {
                                    // Some code to undo the change.
                                  },
                                )));
                          } else {
                            Navigator.pop(context);
                          }
                        }
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUpperBoxGradient() {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[Colors.tealAccent[400], Colors.teal],
          ),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(0.0),
              topRight: Radius.circular(0.0),
              bottomLeft: Radius.circular(40.0),
              bottomRight: Radius.circular(40.0))),
    );
  }

  Widget _buildImage() {
    String defaultImg = 'https://static.thenounproject.com/png/187803-200.png';
    return ClipOval(
      child: Material(
        color: Colors.white,
        child: Ink.image(
          image: image == null ? NetworkImage(defaultImg) : FileImage(image),
          fit: BoxFit.cover,
          width: 128,
          height: 128,
          child: InkWell(
            onTap: () {
              _chooseImage();
            },
          ),
        ),
      ),
    );
  }

  void _chooseImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      image = File(pickedFile?.path);
    });
    if (pickedFile.path == null) retrieveLostData();
  }

  Future<void> retrieveLostData() async {
    final LostData response = await ImagePicker().getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        image = File(response.file.path);
      });
    } else {
      print(response.file);
    }
  }
}
