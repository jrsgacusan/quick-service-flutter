import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:quick_service_clone/models/user_data.dart';
import 'package:quick_service_clone/services/storage_service.dart';
import 'package:quick_service_clone/shared/constants.dart';
import 'package:quick_service_clone/shared/widgets/button_widget.dart';
import 'package:quick_service_clone/shared/widgets/loading_widget.dart';
import 'package:quick_service_clone/shared/widgets/snackbar_widget.dart';

class SendRequirementsScreen extends StatefulWidget {
  @override
  _SendRequirementsScreenState createState() => _SendRequirementsScreenState();
}

class _SendRequirementsScreenState extends State<SendRequirementsScreen> {
  //states

  File _selfie;
  File _validID;
  File _cerification;
  bool isLoading = false;

  Future _getSelfieImage() async {
    final image = await ImagePicker().getImage(source: ImageSource.camera);
    setState(() {
      _selfie = File(image?.path);
    });
  }

  Future _getIDImage() async {
    final image = await ImagePicker().getImage(source: ImageSource.camera);
    setState(() {
      _validID = File(image?.path);
    });
  }

  Future _getCertificationImage() async {
    final image = await ImagePicker().getImage(source: ImageSource.camera);
    setState(() {
      _cerification = File(image?.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List args = ModalRoute.of(context).settings.arguments;
    final bool clientMode = args[1];
    final UserData myData = args[0];
    return isLoading
        ? Loading(
            text: 'Submitting requirements...',
          )
        : Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.black54),
              elevation: 0,
              backgroundColor: Colors.transparent,
              centerTitle: true,
              title: Text(
                'Send the following requirements',
                style: TextStyle(color: Colors.black54),
              ),
            ),
            body: _buildBody(context, clientMode, myData),
          );
  }

  Widget _buildBody(BuildContext context, bool clientMode, UserData myData) {
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 0),
                child: Material(
                  color: _selfie == null ? Colors.grey[200] : Colors.green[200],
                  child: InkWell(
                    onTap: () async {
                      await _getSelfieImage();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: FittedBox(
                        fit: BoxFit.fitHeight,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.face,
                                color: Colors.black54,
                                size: 120,
                                semanticLabel:
                                    'Text to announce in accessibility modes',
                              ),
                              Text(
                                'Selfie image',
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 24,
                                    letterSpacing: 2),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )),
          Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 0),
                child: Material(
                  color:
                      _validID == null ? Colors.grey[200] : Colors.green[200],
                  child: InkWell(
                    onTap: () async {
                      await _getIDImage();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: FittedBox(
                        fit: BoxFit.fitHeight,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.perm_identity,
                                color: Colors.black54,
                                size: 120,
                                semanticLabel:
                                    'Text to announce in accessibility modes',
                              ),
                              Text(
                                'Valid ID',
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 24,
                                    letterSpacing: 2),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )),
          clientMode
              ? SizedBox()
              : Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 0),
                    child: Material(
                      color: _cerification == null
                          ? Colors.grey[200]
                          : Colors.green[200],
                      child: InkWell(
                        onTap: () async {
                          await _getCertificationImage();
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: FittedBox(
                            fit: BoxFit.fitHeight,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.library_books_rounded,
                                    color: Colors.black54,
                                    size: 120,
                                    semanticLabel:
                                        'Text to announce in accessibility modes',
                                  ),
                                  Text(
                                    'Certification',
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 24,
                                        letterSpacing: 2),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 16),
            child: RaisedGradientButton(
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                gradient: LinearGradient(
                  colors: <Color>[Colors.tealAccent[400], Colors.teal],
                ),
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  if (clientMode) {
                    if (_selfie != null && _validID != null) {
                      await StorageService(uid: myData.uid)
                          .uploadClientRequirements(_selfie, _validID, myData);
                      Navigator.pop(context);
                      SnackbarWidget(context: context,onPressed:(){} ,label:'' ,text: 'Wait for the administrators to verify your requirements.').showSnackbar();
                    } else {
                      SnackbarWidget(context: context,onPressed:(){} ,label:'' ,text: 'Submit the following requirements.').showSnackbar();
                    }
                  } else {
                    if (_selfie != null &&
                        _validID != null &&
                        _cerification != null) {
                      await StorageService(uid: myData.uid)
                          .uploadServiceProviderRequirements(
                              _selfie, _validID, _cerification, myData);
                      Navigator.pop(context);
                      SnackbarWidget(context: context,onPressed:(){} ,label:'' ,text: 'Wait for the administrators to verify your requirements.').showSnackbar();
                    } else {
                      SnackbarWidget(context: context,onPressed:(){} ,label:'' ,text: 'Submit the following requirements.').showSnackbar();
                    }
                  }
                  setState(() {
                    isLoading = false;
                  });
                }),
          )
        ],
      ),
    );
  }
}
