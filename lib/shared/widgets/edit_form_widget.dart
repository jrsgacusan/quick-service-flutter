import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_service_clone/models/user_data.dart';
import 'package:quick_service_clone/services/database_service.dart';
import 'package:quick_service_clone/shared/constants.dart';
import 'package:quick_service_clone/shared/widgets/button_widget.dart';

class EditFormWidget extends StatefulWidget {
  int whichToEdit;
  UserData data;
  String initVal;

  EditFormWidget({this.data, this.whichToEdit, this.initVal});

  @override
  _EditFormWidgetState createState() => _EditFormWidgetState();
}

class _EditFormWidgetState extends State<EditFormWidget> {
  final _formKey = GlobalKey<FormState>();
  String _currentValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      padding: EdgeInsets.all(18),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              maxLines: 4,
              minLines: 1,
              validator: (val) {
                if (widget.whichToEdit == 1) {
                  return val.length == 0 || val.length > 300
                      ? "Invalid value."
                      : null;
                } else {
                  return val.length == 0 ? "Invalid value." : null;
                }
              },
              onChanged: (val) {
                setState(() {
                  _currentValue = val;
                });
              },
              initialValue: widget.initVal,
              decoration: textInputDecoration.copyWith(
                  hintText: 'Enter value here',
                  helperText: widget.whichToEdit == 1
                      ? (_currentValue == null
                          ? "${widget.initVal.length}/300"
                          : "${_currentValue.length}/300")
                      : null),
            ),
            SizedBox(
              height: 8,
            ),
            RaisedGradientButton(
                child: Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
                gradient: LinearGradient(
                  colors: <Color>[Colors.tealAccent[400], Colors.teal],
                ),
                onPressed: () async {
                  print('button clicked');

                  if (_formKey.currentState.validate()) {
                    if (_currentValue != null) {
                      UserData _myData = widget.data;
                      if (widget.whichToEdit == 1) {
                        _myData.sellerInfo = _currentValue;
                      } else if (widget.whichToEdit == 2) {
                        _myData.previousSchool = _currentValue;
                      } else {
                        _myData.educationalAttainment = _currentValue;
                      }
                      DatabaseService(uid: _myData.uid).updateUserData(_myData);

                      Navigator.pop(context);
                      Get.snackbar("Successful", "Update successful.");
                    } else {
                      Get.snackbar("Hey", "You did not edit change anything.");
                    }
                  }
                }),
          ],
        ),
      ),
    );
  }
}
