import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:quick_service_clone/models/user_data.dart';
import 'file:///D:/Repositories/Repository-Flutter/quick_service_clone/lib/screens/authenticated/client_mode/client_edit_profile/client_change_pass_form.dart';
import 'package:quick_service_clone/services/auth_service.dart';
import 'package:quick_service_clone/services/database_service.dart';
import 'package:quick_service_clone/services/storage_service.dart';
import 'package:quick_service_clone/shared/constants.dart';
import 'package:quick_service_clone/shared/widgets/bottom_form_widget.dart';
import 'package:quick_service_clone/shared/widgets/button_widget.dart';
import 'package:quick_service_clone/shared/widgets/loading_widget.dart';
import 'package:quick_service_clone/shared/widgets/circle_img_clickable_widget.dart';
import 'package:quick_service_clone/shared/widgets/snackbar_widget.dart';

class ClientEditProfile extends StatefulWidget {
  @override
  _ClientEditProfileState createState() => _ClientEditProfileState();
}

class _ClientEditProfileState extends State<ClientEditProfile> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  String bio = "";
  String name;

  int age;

  int number;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: AuthService().currentUserUid).myData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData myData = snapshot.data;
            return isLoading
                ? Loading(text: 'Saving...')
                : Scaffold(
                    backgroundColor: Colors.grey[200],
                    appBar: AppBar(
                      iconTheme: IconThemeData(color: Colors.black54),
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      centerTitle: true,
                      title: Text(
                        'Edit profile',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                    body: LoaderOverlay(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: Form(
                          key: _formKey,
                          child: Center(
                            child: ListView(
                              children: <Widget>[
                                CircleImgClickableWidget(
                                  imagePath: myData.profileImageUrl,
                                  onClicked: () {
                                    _chooseImageAndUpload(myData, context);
                                  },
                                  iconColor: Colors.teal,
                                  icon: Icons.camera,
                                ),
                                Divider(
                                  height: 32,
                                ),
                                TextFormField(
                                  validator: (val) {
                                    if (val.length > 300) {
                                      return "Don't exceed 300 characters";
                                    } else if (val.isEmpty || val.length == 0) {
                                      return "Add bio";
                                    } else {
                                      return null;
                                    }
                                  },
                                  initialValue: myData.bio ?? bio,
                                  onChanged: (val) {
                                    setState(() {
                                      bio = val;
                                    });
                                  },
                                  decoration: textInputDecoration.copyWith(
                                      hintText: 'Bio',
                                      counterText: bio == null
                                          ? "0/300"
                                          : "${bio.length}/300",
                                      counterStyle: TextStyle(
                                          color: bio.length > 300
                                              ? Colors.red
                                              : Colors.green,
                                          fontSize: 12)),
                                  maxLines: 5,
                                  minLines: 1,
                                ),
                                Divider(
                                  height: 32,
                                ),
                                TextFormField(
                                  onChanged: (val) {
                                    setState(() {
                                      name = val;
                                    });
                                  },
                                  validator: (val) {
                                    return val.length == 0
                                        ? "Invalid name"
                                        : null;
                                  },
                                  initialValue: myData.name,
                                  decoration: textInputDecoration.copyWith(
                                      hintText: 'Name'),
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    SnackbarWidget(
                                            context: context,
                                            onPressed: () {},
                                            label: '',
                                            text: "Cannot edit your email.")
                                        .showSnackbar();
                                  },
                                  child: TextFormField(
                                    enabled: false,
                                    initialValue: myData.email,
                                    decoration: textInputDecoration.copyWith(
                                        hintText: 'Email'),
                                  ),
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                TextFormField(
                                  onChanged: (val) {
                                    setState(() {
                                      age = int.parse(val);
                                    });
                                  },
                                  validator: (val) => !(int.parse(val) >= 18 &&
                                              int.parse(val) <= 75) ||
                                          val.isEmpty
                                      ? 'Invalid age'
                                      : null,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]'))
                                  ],
                                  initialValue: myData.age.toString(),
                                  decoration: textInputDecoration.copyWith(
                                      hintText: 'Age'),
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                TextFormField(
                                  onChanged: (val) {
                                    setState(() {
                                      number = int.parse(val);
                                    });
                                  },
                                  validator: (val) =>
                                      (val.length != 11 && val.length != 10) ||
                                              val.isEmpty
                                          ? 'Invalid phone number'
                                          : null,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]'))
                                  ],
                                  initialValue: myData.number.toString(),
                                  decoration: textInputDecoration.copyWith(
                                      hintText: 'Phone number'),
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                RaisedGradientButton(
                                    child: Text(
                                      'Save',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                    gradient: LinearGradient(
                                      colors: <Color>[
                                        Colors.tealAccent[400],
                                        Colors.teal
                                      ],
                                    ),
                                    onPressed: () {
                                      if (_formKey.currentState.validate()) {
                                        _saveData(myData, context);
                                      }
                                    }),
                                SizedBox(
                                  height: 16,
                                ),
                                RaisedGradientButton(
                                    child: Text(
                                      'Change password',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                    gradient: LinearGradient(
                                      colors: <Color>[
                                        Colors.tealAccent[400],
                                        Colors.teal
                                      ],
                                    ),
                                    onPressed: () {
                                      BottomFormWidget(
                                          context: context,
                                          child: ClientChangePassForm()).showForm();
                                    }),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
          } else {
            return Loading(text: 'Fetching data');
          }
        });
  }

  void _chooseImageAndUpload(UserData myData, BuildContext context) async {
    UserData data = myData;
    StorageService _storage = StorageService(uid: myData.uid);
    DatabaseService _database = DatabaseService(uid: myData.uid);

    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        isLoading = true;
      });
      dynamic response =
          await _storage.uploadProfileImage(File(pickedFile?.path));
      if (response is! Exception) {
        _storage.profileImagesRef
            .child(myData.uid)
            .getDownloadURL()
            .then((value) async {
          data.profileImageUrl = value;
          await _database.updateUserData(data);
          SnackbarWidget(
                  context: context,
                  onPressed: () {},
                  label: '',
                  text: 'Image uploaded.')
              .showSnackbar();
        });
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  void _saveData(UserData myData, BuildContext context) async {
    final DatabaseService _database = DatabaseService(uid: myData.uid);
    UserData data = myData;
    name != null ? data.name = name : null;
    age != null ? data.age = age : null;
    bio != "" ? data.bio = bio : null;
    number != null ? data.number = number : null;

    setState(() {
      isLoading = true;
    });

    await _database.updateUserData(data);

    setState(() {
      isLoading = false;
    });
    SnackbarWidget(
            context: context,
            onPressed: () {},
            label: '',
            text: 'Changes saved.')
        .showSnackbar();
  }
}
